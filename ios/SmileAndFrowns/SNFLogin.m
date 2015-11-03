
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

@interface SNFLogin ()
@property SNFUserService * service;
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
	self.service = [[SNFUserService alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacebookLogin:) name:ATIFacebookAuthHandlerSessionChange object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction) facebookLogin:(id)sender {
	[[ATIFacebookAuthHandler instance] login];
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
				[self displayAlert:error.localizedDescription withTitle:@"Error"];
				return;
			}
			NSLog(@"%@ : %@", user.username, [[SNFModel sharedInstance] lastLoggedInUsername]);
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			[self syncAfterLogin:hasUserChanged];
		}];
		
	} else if(msg) {
		
		[self displayAlert:msg withTitle:@"Error"];
		
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
			
			[self displayAlert:error.localizedDescription withTitle:@"Login Error"];
			
		} else {
			
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			[self syncAfterLogin:hasUserChanged];
			
		}
	}];
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
			[self displayAlert:error.localizedDescription withTitle:@"Sync Error"];
			return;
		}
		
		//TODO:
		//[[SNFSyncService instance] removeObjectsForOtherUsers:[SNFModel sharedInstance].loggedInUser];
		
		[self syncPredefinedBoards];
	}];
}

- (void) syncPredefinedBoards {
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	hud.labelText = @"Syncing Board Data";
	
	[[SNFSyncService instance] syncPredefinedBoardsWithCompletion:^(NSError *error, NSObject *boardData) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayAlert:error.localizedDescription withTitle:@"Sync Error"];
			return;
		}
		
		[self closeModal];
		
	}];
}

- (void) displayAlert:(NSString *) msg withTitle:(NSString *) title {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction OKAction]];
	[self presentViewController:alert animated:TRUE completion:nil];
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

- (IBAction) cancel:(id)sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction) createAccount:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFCreateAccount * createAccount = [[SNFCreateAccount alloc] init];
		
		if(self.nextViewController) {
			createAccount.nextViewController = self.nextViewController;
		}
		
		[[AppDelegate rootViewController] presentViewController:createAccount animated:TRUE completion:nil];
		
	}];
}

- (IBAction) forgotPassword:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFPasswordReset * reset = [[SNFPasswordReset alloc] init];
		[[AppDelegate rootViewController] presentViewController:reset animated:TRUE completion:nil];
		
	}];
}

@end
