
#import "SNFLogin.h"
#import "AppDelegate.h"
#import "SNFCreateAccount.h"
#import "SNFPasswordReset.h"
#import "SNFUserService.h"
#import "SNFModel.h"

@interface SNFLogin ()
@property SNFUserService * service;
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
	self.service = [[SNFUserService alloc] init];
}

- (IBAction) login:(id) sender {
	
	[self.service loginWithEmail:self.email.text andPassword:self.password.text withCompletion:^(NSError *error, SNFUser *user) {
		if(error) {
			
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Login Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				
			}]];
			
			[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			
		} else {
			
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
				
				if(self.nextViewControllerAfterLogin) {
					[[AppDelegate rootViewController] presentViewController:self.nextViewControllerAfterLogin animated:TRUE completion:^{
						
					}];
				}
			}];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

- (IBAction) createAccount:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFCreateAccount * createAccount = [[SNFCreateAccount alloc] init];
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
