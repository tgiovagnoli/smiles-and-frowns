
#import "SNFCreateAccount.h"
#import "AppDelegate.h"

@interface SNFCreateAccount ()
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

@end
