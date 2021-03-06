
#import "SNFCreateAccount.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"
#import "SNFLogin.h"
#import "NSTimer+Blocks.h"
#import "ATIFacebookAuthHandler.h"
#import "UIAlertAction+Additions.h"
#import "SNFSyncService.h"
#import "UIViewController+Alerts.h"
#import "ATITwitterAuthHandler.h"
#import "SNFLauncher.h"
#import "SNFAcceptInvite.h"
#import "SNFBoardList.h"
#import "SNFViewController.h"

@interface SNFCreateAccount ()
@property SNFUserService * service;
@property NSArray * genders;
@property NSTimer * pickerTimer;
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.service = [[SNFUserService alloc] init];
	
	self.firstname.delegate = self;
	self.lastname.delegate = self;
	self.email.delegate = self;
	self.password.delegate = self;
	self.passwordConfirm.delegate = self;
	
	[self startBannerAd];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacebookLogin:) name:ATIFacebookAuthHandlerSessionChange object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onTwitterLogin:) name:ATITwitterAuthHandlerSessionChange object:nil];
	
	[self decorate];
}

- (void) decorate {
	[SNFFormStyles roundEdgesOnButton:self.signupButton];
	[SNFFormStyles roundEdgesOnButton:self.loginButton];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	
	if(textField == self.email) {
		[self.firstname becomeFirstResponder];
		return NO;
	}
	
	if(textField == self.firstname) {
		[self.lastname becomeFirstResponder];
		return NO;
	}
	
	if(textField == self.lastname) {
		[self.password becomeFirstResponder];
		return NO;
	}
	
	if(textField == self.password) {
		[self.passwordConfirm becomeFirstResponder];
		return NO;
	}
	
	if(textField == self.passwordConfirm) {
		[self signup:nil];
		[self.view endEditing:TRUE];
		return YES;
	}
	
	return YES;
}

- (IBAction) signup:(id) sender {
	SNFUserService * service = [[SNFUserService alloc] init];
	
	NSDictionary * data = @{
		@"email":self.email.text,
		@"firstname":self.firstname.text,
		@"lastname":self.lastname.text,
		@"password":self.password.text,
		@"password_confirm":self.passwordConfirm.text,
	};
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[service createAccountWithData:data andCompletion:^(NSError * error, SNFUser *user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				[self displayOKAlertWithTitle:@"Signup Error" message:error.localizedDescription completion:nil];
			}
		} else {
			
			[SNFModel sharedInstance].loggedInUser = user;
			[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
			
			[self syncAfterLogin:nil];
		}
	}];
}

- (IBAction) cancel:(id) sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction) login:(id) sender {
	if([[AppDelegate rootViewController] isKindOfClass:[SNFLauncher class]]) {
		
		SNFLauncher * launcher = (SNFLauncher *)[AppDelegate rootViewController];
		
		[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
			
			SNFLogin * login = [[SNFLogin alloc] initWithSourceView:launcher.loginButton sourceRect:CGRectZero contentSize:CGSizeMake(500,420)];
			
			if(self.nextViewController) {
				login.nextViewController = self.nextViewController;
			}
			
			[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
		}];
		
	}
}

- (IBAction) facebook:(id) sender {
	[[ATIFacebookAuthHandler instance] login];
}

- (IBAction) twitter:(id)sender {
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
			[self syncAfterLogin:hasUserChanged];
			
		}];
		
	} else if(msg) {
		
		[self displayOKAlertWithTitle:@"Error" message:msg completion:nil];
		
	}
}

- (void) syncAfterLogin:(BOOL) hasUserChanged {
	
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
		
		[self closeModal:TRUE];
	}];
}

- (void) closeModal:(BOOL) goesToBoards {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		if(self.nextViewController) {
			
			if([self.nextViewController isKindOfClass:[SNFAcceptInvite class]]) {
				if(goesToBoards) {
					SNFAcceptInvite * invite = (SNFAcceptInvite *)self.nextViewController;
					invite.cancelGoesToBoardsList = TRUE;
				}
			}
			
			[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
			
		} else {
			
			if(goesToBoards) {
				SNFViewController * list = [[SNFViewController alloc] init];
				[AppDelegate instance].window.rootViewController = list;
			}
			
		}
	}];
}

@end
