
#import "SNFPasswordReset.h"
#import "AppDelegate.h"
#import "SNFUserService.h"
#import "UIView+LayoutHelpers.h"
#import "NSTimer+Blocks.h"
#import "UIViewController+Alerts.h"
#import "SNFFormStyles.h"

@interface SNFPasswordReset ()
@end

@implementation SNFPasswordReset

- (void) viewDidLoad {
	[super viewDidLoad];
	[self startBannerAd];
	
	[SNFFormStyles roundEdgesOnButton:self.resetButton];
}

- (IBAction) resetPassword:(id) sender {
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	SNFUserService * service = [[SNFUserService alloc] init];
	
	[service resetPasswordForEmail:self.email.text andCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"OK" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
				[self presentViewController:alert animated:TRUE completion:nil];
			}
			return;
		}
		
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Check your email for a new password" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alert animated:TRUE completion:^{
			[self cancel:nil];
		}];
		
	}];
}

- (IBAction) cancel:(id)sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
