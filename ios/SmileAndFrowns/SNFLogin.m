
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
	self.formView.height -= 256;
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.scrollViewBottom.constant == 0) {
		return;
	}
	self.scrollViewBottom.constant = 0;
	self.formView.height += 256;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.scrollView.height);
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
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				
			}]];
			
			[self presentViewController:alert animated:YES completion:^{}];
			
		} else {
			
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
				
				//show next view controller if needed.
				if(self.nextViewController) {
					
					//don't show next view controller if it's an accept invite code.
					//if a user logs in successfully they can just accept the invite from the invites view.
					if([self.nextViewController isKindOfClass:[SNFAcceptInvite class]]) {
						
						//if main view controller is being shown, show invites.
						if([SNFViewController instance]) {
							
							[[SNFViewController instance] showInvitesAnimated:TRUE];
						
						} else {
							
							SNFViewController * root = [[SNFViewController alloc] init];
							root.firstTab = SNFTabInvites;
							[AppDelegate instance].window.rootViewController = root;
							
						}
						
					} else {
						[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
					}
				}
				
				if(self.delegate) {
					[self.delegate login:self didLoginWithUser:user];
				}
			}];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	if(self.delegate) {
		[self.delegate loginCancelled:self];
	}
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
