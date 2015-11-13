
#import "UIImageView+NSURLCache.h"

const NSInteger UIImageViewNSURLCacheErrorResponseCode = 1;
const NSInteger UIimageViewNSURLCacheErrorContentType = 2;

static NSURLCache * _cacheURL;

@implementation UIImageView (NSURLCache)

- (void) setupCache {
	if(!_cacheURL) {
		_cacheURL = [[NSURLCache alloc] initWithMemoryCapacity:10*1024*1024 diskCapacity:100*1024*1024 diskPath:nil]; //10MB memory, 100MB disk
		[NSURLCache setSharedURLCache:_cacheURL];
	}
}

- (void) cacheResponse:(NSURLResponse *) response forRequest:(NSURLRequest *) request data:(NSData *) data error:(NSError **) error {
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
	if(httpResponse.statusCode != 200) {
		*error = [NSError errorWithDomain:@"com.apptitude.UIImageView-NSURLCache" code:UIImageViewNSURLCacheErrorResponseCode userInfo:@{NSLocalizedDescriptionKey:@"Response from server was not 200"}];
		return;
	}
	
	NSString * contentType = [[httpResponse allHeaderFields] objectForKey:@"Content-Type"];
	NSArray * acceptedContentTypes = @[@"image/png",@"image/jpg",@"image/jpeg",@"image/bitmap"];
	if(![acceptedContentTypes containsObject:contentType]) {
		*error = [NSError errorWithDomain:@"com.apptitude.UIImageView-NSURLCache" code:UIimageViewNSURLCacheErrorContentType userInfo:@{NSLocalizedDescriptionKey:@"Response was not an image"}];
		return;
	}
	
	NSCachedURLResponse * cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
	[_cacheURL storeCachedResponse:cachedResponse forRequest:request];
}

- (void) setImageForRequest:(NSURLRequest *) request withCompletion:(UIImageViewNSURLCache) completion {
	[self setupCache];
	
	if(request.cachePolicy != NSURLRequestReturnCacheDataElseLoad) {
		NSLog(@"[UIImageView+NSURLCache] WARNING: setImageForRequest: The request's cache policy is not set to NSURLRequestReturnCacheDataElseLoad");
	}
	
	if([_cacheURL cachedResponseForRequest:request]) {
		//NSLog(@"[UIImageView+NSURLCache] cache hit for image url : %@",request.URL);
		NSCachedURLResponse * response = [_cacheURL cachedResponseForRequest:request];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.image = [UIImage imageWithData:response.data];
			completion(nil,self.image);
		});
		return;
	}
	
	NSLog(@"[UIImageView+NSURLCache] cache miss for url: %@",request.URL);
	
	NSURLSessionDataTask * imageTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * cacheError = nil;
			[self cacheResponse:response forRequest:request data:data error:&cacheError];
			
			if(cacheError) {
				NSLog(@"[UIImageView+NSURLCache] cache error: %@",error);
				completion(cacheError,nil);
			}
			
			if(data) {
				self.image = [UIImage imageWithData:data];
				completion(nil,self.image);
			}
		});
	}];
	
	[imageTask resume];
	
}

- (void) setImageForURL:(NSURL *) url withCompletion:(UIImageViewNSURLCache) completion; {
	NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:60];
	[self setImageForRequest:request withCompletion:completion];
}

@end
