
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFUserService.h"
#import "SNFViewController.h"

@interface SNFAcceptInvite ()
@property SNFUserService * service;
@end

@implementation SNFAcceptInvite

- (void) viewDidLoad {
	[super viewDidLoad];
	if([SNFModel sharedInstance].pendingInviteCode) {
		self.inviteCodeField.text = [SNFModel sharedInstance].pendingInviteCode;
	}
}

- (IBAction) joinBoard:(id) sender {
	
	self.service = [[SNFUserService alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service acceptInviteCode:self.inviteCodeField.text andCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Invitation Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		NSLog(@"TODO: Need to sync in order to get new boards the user just joines");
		
		[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
		[[SNFViewController instance] showBoards];
		
	}];
}

- (IBAction) cancel:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
