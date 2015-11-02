
#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

#define ATIFacebookAuthHandlerSessionChange @"ATIFacebookAuthHandlerSessionChange"

@interface ATIFacebookAuthHandler : NSObject

+ (ATIFacebookAuthHandler *)sharedInstance;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;
- (void)login;
- (void)logout;

@end
