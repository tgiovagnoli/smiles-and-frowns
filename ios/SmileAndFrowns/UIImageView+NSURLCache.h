
#import <UIKit/UIKit.h>

extern const NSInteger UIImageViewNSURLCacheErrorResponseCode;
extern const NSInteger UIimageViewNSURLCacheErrorContentType;

typedef void(^UIImageViewNSURLCache)(NSError * error, UIImage * image);

@interface UIImageView (NSURLCache)

- (void) setImageForURL:(NSURL *) url withCompletion:(UIImageViewNSURLCache) completion;
- (void) setImageForRequest:(NSURLRequest *) request withCompletion:(UIImageViewNSURLCache) completion;

@end
