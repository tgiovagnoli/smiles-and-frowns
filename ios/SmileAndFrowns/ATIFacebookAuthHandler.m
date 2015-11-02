#import "ATIFacebookAuthHandler.h"

static ATIFacebookAuthHandler *_instance;

@implementation ATIFacebookAuthHandler

+ (ATIFacebookAuthHandler *)sharedInstance{
	if(!_instance){
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
	[[NSNotificationCenter defaultCenter] postNotificationName:ATIFacebookAuthHandlerSessionChange object:self userInfo:@{@"session": session, @"state": [NSNumber numberWithUnsignedInteger:state]}];
	
	if (!error && state == FBSessionStateOpen) {
		NSLog(@"Session opened");
		NSObject * tokenData =  FBSession.activeSession.accessTokenData;
		NSLog(@"%@", tokenData);
		return;
	}
	
	if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
		NSLog(@"Session closed");
	}
	
	// Handle errors
	if (error){
		NSLog(@"Error");
		NSString *alertText;
		NSString *alertTitle;
		// If the error requires people using an app to make an action outside of the app in order to recover
		if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
			alertTitle = @"Something went wrong";
			alertText = [FBErrorUtility userMessageForError:error];
			[self showMessage:alertText withTitle:alertTitle];
		} else {
			// If the user cancelled login, do nothing
			if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
				NSLog(@"User cancelled login");
				// Handle session closures that happen outside of the app
			} else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
				alertTitle = @"Session Error";
				alertText = @"Your current session is no longer valid. Please log in again.";
				[self showMessage:alertText withTitle:alertTitle];
				
				// Here we will handle all other errors with a generic error message.
				// We recommend you check our Handling Errors guide for more information
				// https://developers.facebook.com/docs/ios/errors/
			} else {
				//Get more error information from the error
				NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
				
				// Show the user an error message
				alertTitle = @"Something went wrong";
				alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
				[self showMessage:alertText withTitle:alertTitle];
			}
		}
		[FBSession.activeSession closeAndClearTokenInformation];
	}
}

- (void) showMessage:(NSString *) message withTitle:(NSString *) title {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
	[alertView show];
}

@end
