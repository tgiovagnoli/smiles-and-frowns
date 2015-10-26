
#import "FTPSyncChilkat.h"
#import "CkoFtp2.h"
#import "CkoTask.h"
#import "CkoFtp2Progress.h"

NSString * const FTPSyncChilkatStarted = @"FTPSyncChilkatStarted";
NSString * const FTPSyncChilkatCompleted = @"FTPSyncChilkatCompleted";
NSString * const FTPSyncChilkatFailed = @"FTPSyncChilkatFailed";

@interface FTPSyncChilkat ()
@property NSString * chilkatFTPKey;
@property NSString * host;
@property NSString * username;
@property NSString * password;
@property NSUInteger syncMode;
@property NSInteger port;
@property BOOL secure;
@property NSURL * remoteDir;
@property NSURL * localDir;
@property CkoFtp2 * chilkatFTP;
@property CkoTask * currentTask;
@property NSTimer * taskMonitor;
@property NSString * currentTaskName;
@end

@implementation FTPSyncChilkat

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super init];
	NSKeyedUnarchiver * coder = (NSKeyedUnarchiver *)aDecoder;
	self.syncMode = [coder decodeIntegerForKey:@"syncMode"];
	self.remoteDir = [coder decodeObjectForKey:@"remoteDir"];
	self.localDir = [coder decodeObjectForKey:@"localDir"];
	self.host = [coder decodeObjectForKey:@"host"];
	self.username = [coder decodeObjectForKey:@"username"];
	self.password = [coder decodeObjectForKey:@"password"];
	self.port = [coder decodeIntegerForKey:@"port"];
	self.secure = [coder decodeBoolForKey:@"secure"];
	return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
	NSKeyedArchiver * coder = (NSKeyedArchiver *)aCoder;
	[coder encodeInteger:self.syncMode forKey:@"syncMode"];
	[coder encodeObject:self.remoteDir forKey:@"remoteDir"];
	[coder encodeObject:self.localDir forKey:@"localDir"];
	[coder encodeObject:self.host forKey:@"host"];
	[coder encodeObject:self.username forKey:@"username"];
	[coder encodeObject:self.password forKey:@"password"];
	[coder encodeInteger:self.port forKey:@"port"];
	[coder encodeBool:self.secure forKey:@"secure"];
}

- (id) initWithChilkatFTPKey:(NSString *) key host:(NSString *) host port:(NSUInteger) port secure:(BOOL) secure username:(NSString *) username password:(NSString *) password {
	self = [super init];
	self.chilkatFTPKey = key;
	self.allowItunesBackup = TRUE;
	self.host = host;
	self.username = username;
	self.password = password;
	self.port = port;
	self.syncMode = 6;
	[self debugLog:TRUE];
	return self;
}

- (void) dealloc {
	if(self.currentTask) {
		[self.currentTask Cancel];
	}
	[self.chilkatFTP Disconnect];
}

- (void) setLocalFTPDir:(NSURL *) url; {
	if(self.currentTaskName) {
		NSLog(@"FTPSyncChilkat is currently running, can't set local FTP dir while syncing.");
		return;
	}
	self.localDir = url;
}

- (void) setRemoteFTPDir:(NSURL *) url; {
	if(self.currentTaskName) {
		NSLog(@"FTPSyncChilkat is currently running, can't set remote FTP dir while syncing.");
		return;
	}
	self.remoteDir = url;
}

- (void) syncRemoteDirectory:(NSURL *) remoteDir toLocalDir:(NSURL *) localDir; {
	if(self.currentTask) {
		NSLog(@"FTPSyncChilkat instances can only sync one dir at a time. Use another instance to sync more.");
		return;
	}
	[self setRemoteDir:remoteDir];
	[self setLocalDir:localDir];
	[self syncFTP];
}

- (void) syncRemoteDirectory:(NSURL *) remoteDir toLocalDir:(NSURL *) localDir withSyncMode:(NSUInteger) mode; {
	if(self.currentTask) {
		NSLog(@"FTPSyncChilkat instances can only sync one dir at a time. Use another instance to sync more.");
		return;
	}
	self.syncMode = mode;
	[self syncRemoteDirectory:remoteDir toLocalDir:localDir];
}

- (void) syncFTP {
	if(!self.chilkatFTP) {
		self.chilkatFTP = [[CkoFtp2 alloc] init];
		if([self.chilkatFTP UnlockComponent:self.chilkatFTPKey] != TRUE) {
			NSLog(@"Chilkat key: (%@) failed to unlock",self.chilkatFTPKey);
			[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
			return;
		}
		
		self.chilkatFTP.Hostname = self.host;
		self.chilkatFTP.Username = self.username;
		self.chilkatFTP.Password = self.password;
		self.chilkatFTP.Port = @(self.port);
		self.secure = self.secure;
		
		//see SyncLocalTree for mode option docs https://www.chilkatsoft.com/refdoc/objcCkoFtp2Ref.html
		self.syncMode = self.syncMode;
		
		if(self.secure) {
			self.chilkatFTP.AuthTls = TRUE;
		}
	}
	
	[self debugLog:TRUE];
	
	NSLog(@"FTP Sync (mode: %i) Remote Dir: %@",(int)self.syncMode,self.remoteDir.path);
	NSLog(@"FTP Sync (mode: %i) Local Dir: %@",(int)self.syncMode,self.localDir.path);
	
	//create dir if needed
	BOOL isdir;
	if(![[NSFileManager defaultManager] fileExistsAtPath:self.localDir.path isDirectory:&isdir]) {
		[[NSFileManager defaultManager] createDirectoryAtPath:self.localDir.path withIntermediateDirectories:TRUE attributes:nil error:nil];
	}
	
	//kick off the ftp process.
	if(![self.chilkatFTP IsConnected]) {
		[self connect];
	} else {
		[self changeDir];
	}
}

- (void) stopMonitor {
	[self.taskMonitor invalidate];
	self.taskMonitor = nil;
}

- (void) startMonitor {
	[self stopMonitor];
	self.taskMonitor = [NSTimer scheduledTimerWithTimeInterval:.5 target:self selector:@selector(checkTask:) userInfo:nil repeats:TRUE];
}

- (void) checkTask:(NSTimer *) timer {
	//http://www.chilkatsoft.com/refdoc/objcCkoFtp2Ref.html
	//NSLog(@"current task finished: %i",self.currentTask.Finished);
	//NSLog(@"status: %@",self.currentTask.Status);
	
	if(self.currentTask.Finished) {
		
		if(self.currentTask.StatusInt.integerValue != 7) {
			NSLog(@"StatusInt != 7 (%@, secure:%i) failed",self.currentTaskName,self.secure);
			[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
			if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidFail:)]) {
				[self.delegate ftpSyncChilkatDidFail:self];
			}
			[self stopMonitor];
			[self clearCurrentTask];
			return;
		}
		
		if([self.currentTask GetResultBool] != TRUE) {
			NSLog(@"GetResultBool failed (%@, secure: %i) failed",self.currentTaskName,self.secure);
			[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
			if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidFail:)]) {
				[self.delegate ftpSyncChilkatDidFail:self];
			}
			[self stopMonitor];
			[self clearCurrentTask];
			return;
		}
		
		if([self.currentTaskName isEqualToString:@"ConnectAsync"]) {
			[self changeDir];
		}
		
		else if([self.currentTaskName isEqualToString:@"ChangeRemoteDirAsync"]) {
			[self sync];
		}
		
		else if([self.currentTaskName isEqualToString:@"SyncLocalTreeAsync"]) {
			[self completed];
		}
		
	}
}

- (void) debugLog:(BOOL) debug; {
	if(debug) {
		NSLog(@"%@",[NSTemporaryDirectory() stringByAppendingString:@"chilkat-ftp.log"]);
		self.chilkatFTP.DebugLogFilePath = [NSTemporaryDirectory() stringByAppendingString:@"chilkat-ftp.log"];
		NSLog(@"Chilkat Debug File: %@",self.chilkatFTP.DebugLogFilePath);
	} else {
		self.chilkatFTP.DebugLogFilePath = nil;
		NSLog(@"Chilkat Debug Turned Off");
	}
}

- (void) clearCurrentTask {
	self.currentTask = nil;
	self.currentTaskName = nil;
}

- (void) completed {
	NSLog(@"Chilkat FTP Sync Completed");
	
	self.syncedFiles = [[self.chilkatFTP SyncedFiles] componentsSeparatedByString:@"\n"];
	if(self.syncedFiles.count == 1 && [[self.syncedFiles objectAtIndex:0] isEqualToString:@""]) {
		self.syncedFiles = [NSArray array];
	}
	
	[self.chilkatFTP Disconnect];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatCompleted object:self];
	if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidComplete:)]) {
		[self.delegate ftpSyncChilkatDidComplete:self];
	}
	
	[self stopMonitor];
	[self clearCurrentTask];
	
	if(!self.allowItunesBackup) {
		[self.localDir setResourceValue:@(1) forKey:NSURLIsExcludedFromBackupKey error:nil];
	}
}

- (void) connect {
	self.currentTask = [self.chilkatFTP ConnectAsync];
	self.currentTaskName = @"ConnectAsync";
	if([self.currentTask Run] != TRUE) {
		NSLog(@"Chilkat ConnectAsync failed");
		[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
		if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidFail:)]) {
			[self.delegate ftpSyncChilkatDidFail:self];
		}
		return;
	}
	[self startMonitor];
}

- (void) changeDir {
	self.currentTask = [self.chilkatFTP ChangeRemoteDirAsync:self.remoteDir.path];
	self.currentTaskName = @"ChangeRemoteDirAsync";
	if([self.currentTask Run] != TRUE) {
		[self.chilkatFTP Disconnect];
		NSLog(@"Chilkat ChangeRemoteDir (%@) failed",self.remoteDir.path);
		[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
		if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidFail:)]) {
			[self.delegate ftpSyncChilkatDidFail:self];
		}
		return;
	}
	[self startMonitor];
}

- (void) sync {
	self.currentTask = [self.chilkatFTP SyncLocalTreeAsync:self.localDir.path mode:@(self.syncMode)];
	self.currentTaskName = @"SyncLocalTreeAsync";
	if([self.currentTask Run] != YES) {
		[self.chilkatFTP Disconnect];
		NSLog(@"Chilkat SyncLocalTreeAsync (%@) failed",self.localDir.path);
		[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatFailed object:self];
		if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidFail:)]) {
			[self.delegate ftpSyncChilkatDidFail:self];
		}
		return;
	}
	[[NSNotificationCenter defaultCenter] postNotificationName:FTPSyncChilkatStarted object:self];
	if(self.delegate && [self.delegate respondsToSelector:@selector(ftpSyncChilkatDidStart:)]) {
		[self.delegate ftpSyncChilkatDidStart:self];
	}
	[self startMonitor];
}

@end
