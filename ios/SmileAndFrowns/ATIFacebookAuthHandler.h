
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

extern NSString * const ATIFacebookAuthHandlerSessionChange;

@interface ATIFacebookAuthHandler : NSObject

+ (ATIFacebookAuthHandler *) instance;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)login;
- (void)logout;

@end
