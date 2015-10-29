
#import "SNFLogin.h"
#import "AppDelegate.h"
#import "SNFCreateAccount.h"
#import "SNFPasswordReset.h"

@interface SNFLogin ()
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) login:(id) sender {
	
	if(self.nextViewControllerAfterLogin) {
		
		[[AppDelegate instance].window.rootViewController dismissViewControllerAnimated:TRUE completion:^{
			
			[[AppDelegate instance].window.rootViewController presentViewController:self.nextViewControllerAfterLogin animated:TRUE completion:^{
				
			}];
			
		}];
		
	}
	
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate instance].window.rootViewController dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

- (IBAction) createAccount:(id) sender {
	[[AppDelegate instance].window.rootViewController dismissViewControllerAnimated:TRUE completion:^{
		
		SNFCreateAccount * createAccount = [[SNFCreateAccount alloc] init];
		[[AppDelegate instance].window.rootViewController presentViewController:createAccount animated:TRUE completion:^{
			
		}];
		
	}];
}

- (IBAction) forgotPassword:(id) sender {
	[[AppDelegate instance].window.rootViewController dismissViewControllerAnimated:TRUE completion:^{
		
		SNFPasswordReset * reset = [[SNFPasswordReset alloc] init];
		[[AppDelegate instance].window.rootViewController presentViewController:reset animated:TRUE completion:^{
			
		}];
		
	}];
}

@end
