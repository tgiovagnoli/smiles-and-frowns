
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface ATIFacebookAuthHandler : NSObject

+ (ATIFacebookAuthHandler *) instance;
- (void)loginWithCompletion:(void(^)(NSError *error,NSString * token)) completion;
- (void)logout;

@end
