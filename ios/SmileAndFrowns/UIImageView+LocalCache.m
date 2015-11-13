
#import "UIImageView+LocalCache.h"

const NSInteger UIImageViewLocalCacheErrorResponseCode = 1;
const NSInteger UIimageViewLocalCacheErrorContentType = 2;

static NSURLCache * _cacheURL;

@implementation UIImageView (LocalCache)

- (void) setupCache {
	_cacheURL = [NSURLCache sharedURLCache];
}

- (void) cacheResponse:(NSURLResponse *) response forRequest:(NSURLRequest *) request data:(NSData *) data error:(NSError **) error {
	NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
	if(httpResponse.statusCode != 200) {
		*error = [NSError errorWithDomain:@"com.apptitude.UIImageView-LocalCache" code:UIImageViewLocalCacheErrorResponseCode userInfo:@{NSLocalizedDescriptionKey:@"Response from server was not 200"}];
		return;
	}
	
	NSString * contentType = [[httpResponse allHeaderFields] objectForKey:@"Content-Type"];
	NSArray * acceptedContentTypes = @[@"image/png",@"image/jpg",@"image/jpeg",@"image/bitmap"];
	if(![acceptedContentTypes containsObject:contentType]) {
		*error = [NSError errorWithDomain:@"com.apptitude.UIImageView-LocalCache" code:UIimageViewLocalCacheErrorContentType userInfo:@{NSLocalizedDescriptionKey:@"Response was not an image"}];
		return;
	}
	
	NSCachedURLResponse * cachedResponse = [[NSCachedURLResponse alloc] initWithResponse:response data:data];
	[_cacheURL storeCachedResponse:cachedResponse forRequest:request];
}

- (void) setImageForRequest:(NSURLRequest *) request withCompletion:(UIImageViewLocalCache) completion {
	if([_cacheURL cachedResponseForRequest:request]) {
		NSCachedURLResponse * response = [_cacheURL cachedResponseForRequest:request];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.image = [UIImage imageWithData:response.data];
		});
		return;
	}
	
	NSLog(@"cache miss for url: %@",request.URL);
	
	NSURLSessionDataTask * imageTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * cacheError = nil;
			[self cacheResponse:response forRequest:request data:data error:&cacheError];
			if(cacheError) {
				NSLog(@"cache error: %@",error);
				completion(cacheError,nil);
			}
			
			if(data) {
				UIImage * image = [UIImage imageWithData:data];
				self.image = image;
			}
		});
	}];
	
	[imageTask resume];
	
}

- (void) setImageForURL:(NSURL *) url withCompletion:(UIImageViewLocalCache) completion; {
	if(!_cacheURL) {
		[self setupCache];
	}
	
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	if([_cacheURL cachedResponseForRequest:request]) {
		NSCachedURLResponse * response = [_cacheURL cachedResponseForRequest:request];
		dispatch_async(dispatch_get_main_queue(), ^{
			self.image = [UIImage imageWithData:response.data];
		});
		return;
	}
	
	NSLog(@"cache miss for url: %@",url);
	
	NSURLSessionDataTask * imageTask = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * cacheError = nil;
			[self cacheResponse:response forRequest:request data:data error:&cacheError];
			if(cacheError) {
				NSLog(@"cache error: %@",error);
				completion(cacheError,nil);
			}
			
			if(data) {
				UIImage * image = [UIImage imageWithData:data];
				self.image = image;
			}
		});
		
	}];
	
	[imageTask resume];
}

@end
