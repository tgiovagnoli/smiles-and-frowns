
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
@property BOOL firstlayout;
@property SNFUserService * service;
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	self.service = [[SNFUserService alloc] init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
		self.formView.frame = self.scrollView.bounds;
		self.scrollView.contentSize = self.scrollView.size;
		[self.scrollView addSubview:self.formView];
	}
}

- (void) keyboardWillShow:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	if(self.scrollViewBottom.constant == keyboardFrameEnd.size.height) {
		return;
	}
	self.formView.height = 364;
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.scrollViewBottom.constant == 0) {
		return;
	}
	self.scrollViewBottom.constant = 0;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.scrollView.height);
	[NSTimer scheduledTimerWithTimeInterval:.2 block:^{
		self.formView.height = self.scrollView.height;
	} repeats:FALSE];
}

- (IBAction) facebookLogin:(id)sender {
	[[ATIFacebookAuthHandler instance] loginWithCompletion:^(NSError *error, NSString *token) {
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		[self.service loginWithFacebookAuthToken:token withCompletion:^(NSError *error, SNFUser *user) {
			
			if(error) {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[self presentViewController:alert animated:TRUE completion:nil];
				return;
			}
			
			[SNFModel sharedInstance].loggedInUser = user;
			
			[self syncAfterLogin];
			
		}];
	}];
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
	
	[self.service loginWithEmail:self.email.text andPassword:self.password.text withCompletion:^(NSError *error, SNFUser *user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:YES completion:^{}];
			
		} else {
			
			[self syncAfterLogin];
			
		}
	}];
}

- (void) syncAfterLogin {
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	hud.labelText = @"Syncing Board Data";
	
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sync Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
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
			SNFViewController * root = [[SNFViewController alloc] init];
			[AppDelegate instance].window.rootViewController = root;
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
