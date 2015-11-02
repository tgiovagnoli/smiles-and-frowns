
#import "SNFFacebookAuthHandler.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

NSString * const SNFFacebookAuthHandlerSessionChange =  @"SNFFacebookAuthHandlerSessionChange";

static SNFFacebookAuthHandler *_instance;

@implementation SNFFacebookAuthHandler

+ (SNFFacebookAuthHandler *) instance {
	if(!_instance){
		_instance = [[SNFFacebookAuthHandler alloc] init];
	}
	return _instance;
}

- (void) login:(void(^)(NSError *error, NSString * token)) completion {
	FBSDKLoginManager * manager = [[FBSDKLoginManager alloc] init];
	//manager.loginBehavior = FBSDKLoginBehaviorNative;
	
	if([FBSDKAccessToken currentAccessToken]) {
		NSLog(@"already logged in");
		NSLog(@"%@",[FBSDKAccessToken currentAccessToken]);
		completion(nil,[FBSDKAccessToken currentAccessToken].tokenString);
		return;
	}
	
	[manager logInWithReadPermissions:@[@"public_profile"] fromViewController:nil handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			NSLog(@"%@",error);
			NSLog(@"fb token: %@",[FBSDKAccessToken currentAccessToken].tokenString);
			if(error) {
				completion(error,nil);
				return;
			}
			completion(nil,[FBSDKAccessToken currentAccessToken].tokenString);
		});
	}];
}

- (void) logout {
	if([FBSDKAccessToken currentAccessToken]) {
		FBSDKLoginManager * manager = [[FBSDKLoginManager alloc] init];
		[manager logOut];
	}
}

@end
