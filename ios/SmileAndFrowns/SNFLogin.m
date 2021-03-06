
#import "SNFLogin.h"
#import "AppDelegate.h"
#import "SNFCreateAccount.h"
#import "SNFPasswordReset.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "MBProgressHUD.h"
#import "NSString+Additions.h"
#import "SNFAcceptInvite.h"
#import "SNFViewController.h"
#import "UIView+LayoutHelpers.h"
#import "UIAlertAction+Additions.h"
#import "SNFSyncService.h"
#import "NSTimer+Blocks.h"
#import "ATIFacebookAuthHandler.h"
#import "ATITwitterAuthHandler.h"
#import "UIViewController+Alerts.h"
#import "SNFLauncher.h"

NSString * const SNFLoginLoggedIn = @"SNFLoginLoggedIn";
NSString * const SNFLoginLogingSyncCompleted = @"SNFLoginSyncCompleted";

@interface SNFLogin ()
@property SNFUserService * service;
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
	self.service = [[SNFUserService alloc] init];
	self.email.delegate = self;
	self.password.delegate = self;
	[self startBannerAd];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacebookLogin:) name:ATIFacebookAuthHandlerSessionChange object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTwitterLogin:) name:ATITwitterAuthHandlerSessionChange object:nil];
	
	[self decorate];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.loginButton];
}


- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	if(textField == self.email) {
		[self.password becomeFirstResponder];
		return NO;
	}
	
	if(textField == self.password) {
		[self login:nil];
		[self.view endEditing:TRUE];
		return YES;
	}
	
	return TRUE;
}

- (IBAction) facebookLogin:(id)sender {
	[[ATIFacebookAuthHandler instance] login];
}

- (IBAction) twitterLogin:(id)sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	[[ATITwitterAuthHandler instance] login];
}

- (void) onTwitterLogin:(NSNotification *) notification {
	[MBProgressHUD hideHUDForView:self.view animated:TRUE];
	
	TWTRSession * session = [[notification userInfo] objectForKey:@"session"];
	NSError * error = notification.userInfo[@"error"];
	
	if(error) {
		NSError * error = notification.userInfo[@"error"];
		[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
		return;
	}
	
	if(session) {
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[self.service loginWithTwitterAuthToken:session.authToken authSecret:session.authTokenSecret withCompletion:^(NSError *error, SNFUser *user) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFLoginLoggedIn object:nil];
			
			[self syncAfterLogin:hasUserChanged];
			
		}];
	}
}

- (void) onFacebookLogin:(NSNotification *) notification {
	FBSessionState state = (FBSessionState)[[[notification userInfo] objectForKey:@"state"] unsignedIntegerValue];
	NSString * msg = [notification userInfo][@"msg"];
	
	if(state == FBSessionStateOpen) {
		NSString * authToken = FBSession.activeSession.accessTokenData.accessToken;
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[self.service loginWithFacebookAuthToken:authToken withCompletion:^(NSError *error, SNFUser *user) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFLoginLoggedIn object:nil];
			
			[self syncAfterLogin:hasUserChanged];
			
		}];
		
	} else if(msg) {
		
		[self displayOKAlertWithTitle:@"Error:" message:msg completion:nil];
		
	}
}

- (IBAction) login:(id) sender {
	
	NSString * msg = nil;
	
	if(self.email.text.isEmpty) {
		msg = @"Enter your email address";
	}
	
	if(!msg && ![self.email.text isValidEmail]) {
		msg = @"Incorrect email format";
	}
	
	if(!msg && self.password.text.isEmpty) {
		msg = @"Enter your password";
	}
	
	if(msg) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service loginWithEmail:self.email.text andPassword:self.password.text withCompletion:^(NSError * error, SNFUser * user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"OK" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				[self displayOKAlertWithTitle:@"Login Error" message:error.localizedDescription completion:nil];
			}
			
		} else {
			
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFLoginLoggedIn object:nil];
			
			[self syncAfterLogin:hasUserChanged];
		}
	}];
}

- (void) syncAfterLogin:(BOOL) hasUserChanged {
	
	NSLog(@"has user changed: %i",hasUserChanged);
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	hud.labelText = @"Syncing Board Data";
	
	if(hasUserChanged) {
		[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
	}
	
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Sync Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:SNFLoginLogingSyncCompleted object:self];
		
		[self closeModal];
	}];
}

- (void) closeModal {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		if(self.nextViewController) {
			[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
		} else if([SNFViewController instance]) {
			[[SNFViewController instance] showBoardsAnimated:TRUE];
		} else {
			//SNFViewController * root = [[SNFViewController alloc] init];
			//[AppDelegate instance].window.rootViewController = root;
		}
		
	}];
}

- (IBAction) cancel:(id) sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction) createAccount:(id) sender {
	if([[AppDelegate rootViewController] isKindOfClass:[SNFLauncher class]]) {
		
		SNFLauncher * launcher = (SNFLauncher *)[AppDelegate rootViewController];
		
		[launcher dismissViewControllerAnimated:TRUE completion:^{
			SNFCreateAccount * createAccount = [[SNFCreateAccount alloc] initWithSourceView:launcher.createAccountButton sourceRect:CGRectZero contentSize:CGSizeMake(500,480)];
			
			if(self.nextViewController) {
				createAccount.nextViewController = self.nextViewController;
			}
			
			[[AppDelegate rootViewController] presentViewController:createAccount animated:TRUE completion:nil];
			
		}];
	}
}

- (IBAction) forgotPassword:(id) sender {
	if([[AppDelegate rootViewController] isKindOfClass:[SNFLauncher class]]) {
		
		SNFLauncher * launcher = (SNFLauncher *)[AppDelegate rootViewController];
		
		[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
			
			SNFPasswordReset * reset = [[SNFPasswordReset alloc] initWithSourceView:launcher.loginButton sourceRect:CGRectZero contentSize:CGSizeMake(500,200)];
			[[AppDelegate rootViewController] presentViewController:reset animated:TRUE completion:nil];
			
		}];
	}
	
}

@end
