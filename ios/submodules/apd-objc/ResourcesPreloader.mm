
#import "ResourcesPreloader.h"
#import "CkoZip.h"
#import "CkoZipProgress.h"

@interface ZipProgress : CkoZipProgress
@property NSObject <ZipProgressDelegate> * delegate;
@end

@interface ResourcesPreloader ()
@property int64_t expectedSize;
@property int64_t bytesDownloaded;
@property NSDate * lastModified;
@property NSFileHandle * resourcesFile;
@property NSURLConnection * connection;
@end

@implementation ResourcesPreloader

+ (ResourcesPreloader *) resourcePreloaderForLocalZipURL:(NSURL *)url {
	NSURL * dataURL = [url URLByAppendingPathExtension:@"rp"];
	NSFileManager * fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:dataURL.path]) {
		return nil;
	}
	NSData * data = [NSData dataWithContentsOfFile:dataURL.path];
	ResourcesPreloader * preloader = [NSKeyedUnarchiver unarchiveObjectWithData:data];
	preloader.localZipURL = url;
	return preloader;
}

+ (BOOL) canRestorePreloaderForLocalZipFile:(NSURL *) url; {
	NSURL * dataURL = [url URLByAppendingPathExtension:@"rp"];
	NSFileManager * fileManager = [NSFileManager defaultManager];
	if(![fileManager fileExistsAtPath:dataURL.path]) {
		return FALSE;
	}
	return TRUE;
}

- (id) init {
	self = [super init];
	self.expectedSize = 0;
	self.bytesDownloaded = 0;
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	NSKeyedUnarchiver * coder = (NSKeyedUnarchiver *)aDecoder;
	self.expectedSize = [coder decodeInt64ForKey:@"expectedSize"];
	self.bytesDownloaded = [coder decodeInt64ForKey:@"bytesDownloaded"];
	self.lastModified = [coder decodeObjectForKey:@"lastModified"];
	self.remoteZipURL = [coder decodeObjectForKey:@"remoteZipURL"];
	self.chilkatKey = [coder decodeObjectForKey:@"chilkatKey"];
	self.alwaysReload = [coder decodeBoolForKey:@"alwaysReload"];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
	NSKeyedArchiver * coder = (NSKeyedArchiver *)aCoder;
	[coder encodeInt64:self.expectedSize forKey:@"expectedSize"];
	[coder encodeInt64:self.bytesDownloaded forKey:@"bytesDownloaded"];
	[coder encodeObject:self.lastModified forKey:@"lastModified"];
	[coder encodeObject:self.remoteZipURL forKey:@"remoteZipURL"];
	[coder encodeObject:self.chilkatKey forKey:@"chilkatKey"];
	[coder encodeBool:self.alwaysReload forKey:@"alwaysReload"];
}

- (void) cancel; {
	[self.connection cancel];
	self.bytesDownloaded = 0;
	self.expectedSize = 0;
	[[NSFileManager defaultManager] removeItemAtURL:self.localZipURL error:nil];
	[[NSFileManager defaultManager] removeItemAtURL:[self serializedDataURL] error:nil];
}

- (void) stop; {
	[self.connection cancel];
}

- (void) createLocalResourcesFile {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	
	[fileManager createDirectoryAtPath:[self.localZipURL URLByDeletingLastPathComponent].path withIntermediateDirectories:TRUE attributes:nil error:nil];
	
	if(![fileManager fileExistsAtPath:self.localZipURL.path]) {
		[fileManager createFileAtPath:self.localZipURL.path contents:nil attributes:nil];
		self.resourcesFile = [NSFileHandle fileHandleForWritingAtPath:self.localZipURL.path];
	}
	
	else {
		self.resourcesFile = [NSFileHandle fileHandleForWritingAtPath:self.localZipURL.path];
		[self.resourcesFile seekToFileOffset:self.bytesDownloaded];
	}
}

- (NSURL *) serializedDataURL {
	return [self.localZipURL URLByAppendingPathExtension:@"rp"];
	
}

- (void) save {
	static bool logged_save_path = FALSE;
	if(!logged_save_path) {
		NSLog(@"ResourcePreloader saving preloader data to: %@",[self serializedDataURL]);
		logged_save_path = TRUE;
	}
	NSData * data = [NSKeyedArchiver archivedDataWithRootObject:self];
	[data writeToFile:[self serializedDataURL].path atomically:TRUE];
}

- (void) resume {
	NSFileManager * fileManager = [NSFileManager defaultManager];
	
	//check if local file is complete first.
	if([fileManager fileExistsAtPath:self.localZipURL.path]) {
		if(self.expectedSize > 0 && self.bytesDownloaded >= self.expectedSize) {
			[self unzip];
			return;
		}
	}
	
	//if always reload, first delete the file.
	if(self.alwaysReload) {
		[fileManager removeItemAtPath:self.localZipURL.path error:nil];
	}
	
	//make local file to download to.
	[self createLocalResourcesFile];
	
	//setup request for download
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:self.remoteZipURL];
	if(self.bytesDownloaded > 0 && !self.alwaysReload) {
		NSString * range = [NSString stringWithFormat:@"bytes=%llu-",self.bytesDownloaded];
		[request setValue:range forHTTPHeaderField:@"Range"];
	}
	
	//if always reload, reset internal vars.
	if(self.alwaysReload) {
		self.bytesDownloaded = 0;
		self.expectedSize = 0;
	}
	
	//start download
	self.connection = [NSURLConnection connectionWithRequest:request delegate:self];
	[self.connection start];
}

- (void) connection:(NSURLConnection *) connection didReceiveData:(NSData *) data {
	[self.resourcesFile writeData:data];
	self.bytesDownloaded += data.length;
	float progress = (float) ( (float) [self bytesDownloaded] / self.expectedSize) / 2;
	[self sendProgress:@(progress)];
	[self save];
}

- (void) connection:(NSURLConnection *) connection didReceiveResponse:(NSURLResponse *) response {
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
	NSDictionary * headers = httpResponse.allHeaderFields;
	
	//check server modification date against original server modification date
	NSString * modified = headers[@"Last-Modified"];
	if(modified) {
		NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.dateFormat = @"EEE',' dd MMM yyyy HH':'mm':'ss 'GMT'";
		
		//if server modified date is greater than the original modified date the file needs to be re-downloaded.
		NSDate * modifiedDate = [dateFormatter dateFromString:modified];
		if([modifiedDate timeIntervalSinceDate:self.lastModified] > 0) {
			NSLog(@"File was modified, redownloading entire file.");
			[self cancel];
			[self resume];
			return;
		} else {
			self.lastModified = modifiedDate;
		}
	}
	
	if(self.expectedSize < 1) {
		self.expectedSize = [response expectedContentLength];
	}
	
	[self save];
}

- (void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {	
	if(self.delegate && [self.delegate respondsToSelector:@selector(resourcesPreloader:zipDownloadFailedWithError:)]) {
		[self.delegate resourcesPreloader:self zipDownloadFailedWithError:error];
	}
}

- (void) connectionDidFinishLoading:(NSURLConnection *) connection {
	NSLog(@"connection did finish loading");
	self.bytesDownloaded = 0;
	self.expectedSize = 0;
	[self save];
	[self performSelectorInBackground:@selector(unzip) withObject:nil];
}

- (void) unzip {
	CkoZip * zip = [[CkoZip alloc] init];
	ZipProgress * progress = [[ZipProgress alloc] init];
	progress.delegate = self;
	[zip setEventCallbackObject:progress];
	
	if([zip UnlockComponent:self.chilkatKey] != TRUE) {
		NSLog(@"Failed to unlock zip for chilkat with key (%@)",self.chilkatKey);
		return;
	}
	
	if([zip OpenZip:self.localZipURL.path] != TRUE) {
		NSLog(@"Failed to open zip file!");
		return;
	}
	
	NSURL * unzipPath = [self.localZipURL URLByDeletingLastPathComponent];
	int unzipCount = [[zip Unzip:unzipPath.path] intValue];
	if(unzipCount < 0) {
		self.bytesDownloaded = 0;
		self.expectedSize = 0;
		[zip CloseZip];
		[self performSelectorOnMainThread:@selector(sendUnzipFailed) withObject:nil waitUntilDone:FALSE];
		[self performSelectorOnMainThread:@selector(save) withObject:nil waitUntilDone:FALSE];
		NSLog(@"error unzipping");
		return;
	}
	
	[zip CloseZip];
	[self performSelectorOnMainThread:@selector(zipComplete) withObject:nil waitUntilDone:FALSE];
}

- (void) zipComplete {
	[[NSFileManager defaultManager] removeItemAtURL:self.localZipURL error:nil];
	[[NSFileManager defaultManager] removeItemAtURL:[self serializedDataURL] error:nil];
	if(self.delegate && [self.delegate respondsToSelector:@selector(resourcesPreloaderCompleted:)]) {
		[self.delegate resourcesPreloaderCompleted:self];
	}
}

- (void) PercentDone:(NSNumber *) pctDone {
	float progress = .5 + ((pctDone.floatValue/100)/2);
	[self performSelectorOnMainThread:@selector(sendProgress:) withObject:@(progress) waitUntilDone:FALSE];
}

- (void) sendUnzipFailed {
	if(self.delegate && [self.delegate respondsToSelector:@selector(resourcesPreloaderUnzipFailed:)]) {
		[self.delegate resourcesPreloaderUnzipFailed:self];
	}
}

- (void) sendProgress:(NSNumber *) progress {
	if(self.delegate && [self.delegate respondsToSelector:@selector(resourcesPreloader:progress:)]) {
		[self.delegate resourcesPreloader:self progress:progress.floatValue];
	}
}

- (void) deleteZipFile; {
	[[NSFileManager defaultManager] removeItemAtURL:self.localZipURL error:nil];
	[[NSFileManager defaultManager] removeItemAtURL:[self serializedDataURL] error:nil];
}

@end

@implementation ZipProgress

- (void) PercentDone:(NSNumber *)pctDone abort:(BOOL *)abort {
	if(self.delegate && [self.delegate respondsToSelector:@selector(PercentDone:)]) {
		[self.delegate PercentDone:pctDone];
	}
}

@end
