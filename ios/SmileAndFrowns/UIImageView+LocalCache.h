
#import <UIKit/UIKit.h>

extern const NSInteger UIImageViewLocalCacheErrorResponseCode;
extern const NSInteger UIimageViewLocalCacheErrorContentType;

typedef void(^UIImageViewLocalCache)(NSError * error, UIImage * image);

@interface UIImageView (LocalCache)

- (void) setImageForURL:(NSURL *) url withCompletion:(UIImageViewLocalCache) completion;
- (void) setImageForRequest:(NSURLRequest *) request withCompletion:(UIImageViewLocalCache) completion;

@end
