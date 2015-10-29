
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"

@interface SNFAcceptInvite ()
@end

@implementation SNFAcceptInvite

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (IBAction) joinBoard:(id)sender {
	
}

- (IBAction) cancel:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
	}];
}

@end
