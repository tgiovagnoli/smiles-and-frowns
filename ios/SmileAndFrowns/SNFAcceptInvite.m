
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "SNFModel.h"

@interface SNFAcceptInvite ()
@end

@implementation SNFAcceptInvite

- (void) viewDidLoad {
	[super viewDidLoad];
	if([SNFModel sharedInstance].pendingInviteCode) {
		self.inviteCodeField.text = [SNFModel sharedInstance].pendingInviteCode;
	}
}

- (IBAction) joinBoard:(id) sender {
	
}

- (IBAction) cancel:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
