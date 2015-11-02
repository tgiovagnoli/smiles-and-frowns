
#import <Foundation/Foundation.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

extern NSString * const SNFFacebookAuthHandlerSessionChange;

@interface SNFFacebookAuthHandler : NSObject

+ (SNFFacebookAuthHandler *) instance;
- (void) login:(void(^)(NSError *error, NSString * token)) completion;
- (void) logout;

@end
