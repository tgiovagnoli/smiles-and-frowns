
#import "SNFPasswordReset.h"
#import "AppDelegate.h"

@interface SNFPasswordReset ()
@end

@implementation SNFPasswordReset

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) resetPassword:(id)sender {
	
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

@end
