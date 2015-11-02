
#import "ATIFacebookAuthHandler.h"

static ATIFacebookAuthHandler * _instance;

@implementation ATIFacebookAuthHandler

+ (ATIFacebookAuthHandler *) instance {
	if(!_instance) {
		_instance = [[ATIFacebookAuthHandler alloc] init];
	}
	return _instance;
}

- (void) loginWithCompletion:(void(^)(NSError *error,NSString * token)) completion; {
	if(FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		completion(nil,FBSession.activeSession.accessTokenData.accessToken);
	} else {
		[FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
			if(error) {
				completion(error,nil);
				return;
			}
			completion(nil,FBSession.activeSession.accessTokenData.accessToken);
		}];
	}
}

- (void) logout {
	[FBSession.activeSession closeAndClearTokenInformation];
}

@end
