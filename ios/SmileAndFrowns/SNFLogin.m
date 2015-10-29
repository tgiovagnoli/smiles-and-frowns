
#import "SNFLogin.h"
#import "AppDelegate.h"

@interface SNFLogin ()
@end

@implementation SNFLogin

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate instance].window.rootViewController dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

@end
