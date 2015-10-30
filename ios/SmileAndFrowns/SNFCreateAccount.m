
#import "SNFCreateAccount.h"
#import "AppDelegate.h"

@interface SNFCreateAccount ()
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) signup:(id)sender {
	
	//TODO: signup
	
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		if(self.nextViewController) {
			[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
