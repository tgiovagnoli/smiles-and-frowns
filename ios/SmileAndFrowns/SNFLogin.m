
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

@interface SNFLogin ()
@property SNFUserService * service;
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
	self.service = [[SNFUserService alloc] init];
}

- (IBAction) login:(id) sender {
	
	if(self.email.text.length < 1 || [self.email.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Enter your email address" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return;
	}
	
	if(![self.email.text isValidEmail]) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Incorrect email format" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return;
	}
	
	if(self.password.text.length < 1 || [self.password.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Enter your password" preferredStyle:UIAlertControllerStyleAlert];
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
							[[SNFViewController instance] showInvites];
						
						} else {
							
							[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
							[[SNFViewController instance] showInvites];
							
						}
						
					} else {
						[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
					}

				}
				
				if(self.delegate){
					[self.delegate login:self didLoginWithUser:user];
				}
			}];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	if(self.delegate){
		[self.delegate loginCancelled:self];
	}
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

- (IBAction) createAccount:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFCreateAccount * createAccount = [[SNFCreateAccount alloc] init];
		if(self.nextViewController) {
			createAccount.nextViewController = self.nextViewController;
		}
		[[AppDelegate rootViewController] presentViewController:createAccount animated:TRUE completion:^{
			
		}];
		
	}];
}

- (IBAction) forgotPassword:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFPasswordReset * reset = [[SNFPasswordReset alloc] init];
		[[AppDelegate rootViewController] presentViewController:reset animated:TRUE completion:^{
			
		}];
		
	}];
}

@end
