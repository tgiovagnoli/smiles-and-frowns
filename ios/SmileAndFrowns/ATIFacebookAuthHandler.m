
#import "ATIFacebookAuthHandler.h"

NSString * const ATIFacebookAuthHandlerSessionChange = @"ATIFacebookAuthHandlerSessionChange";

static ATIFacebookAuthHandler *_instance;

@implementation ATIFacebookAuthHandler

+ (ATIFacebookAuthHandler *) instance {
	if(!_instance) {
		_instance = [[ATIFacebookAuthHandler alloc] init];
	}
	return _instance;
}

- (void) login {
	if(FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
		[self sessionStateChanged:FBSession.activeSession state:FBSession.activeSession.state error:nil];
	} else {
		[FBSession openActiveSessionWithReadPermissions:@[@"public_profile",@"email"] allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
			[self sessionStateChanged:session state:state error:error];
		}];
	}
}

- (void) logout {
	[FBSession.activeSession closeAndClearTokenInformation];
}

- (void) sessionStateChanged:(FBSession *) session state:(FBSessionState) state error:(NSError *) error {
	NSMutableDictionary * info = [NSMutableDictionary dictionaryWithDictionary:@{@"session":session,@"state":@(state)}];
	
	if(!error && state == FBSessionStateOpen) {
		[[NSNotificationCenter defaultCenter] postNotificationName:ATIFacebookAuthHandlerSessionChange object:self userInfo:info];
		return;
	}
	
	if(error) {
		info[@"error"] = error;
	}
	
	if(state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed) {
		NSLog(@"Session closed");
	}
	
	NSString * msg = nil;
	
	if(error) {
		// If the error requires people using an app to make an action outside of the app in order to recover
		if ([FBErrorUtility shouldNotifyUserForError:error] == YES) {
			msg = [FBErrorUtility userMessageForError:error];
		} else {
			// If the user cancelled login, do nothing
			if([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
				msg = @"You cancelled login";
			} else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
				msg = @"Your current session is no longer valid. Please log in again.";
			} else {
				//Get more error information from the error
				NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
				msg = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
			}
		}
		
		[FBSession.activeSession closeAndClearTokenInformation];
	}
	
	if(msg) {
		info[@"msg"] = msg;
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:ATIFacebookAuthHandlerSessionChange object:self userInfo:info];
}

@end
