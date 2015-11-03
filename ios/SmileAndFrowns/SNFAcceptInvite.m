
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFUserService.h"
#import "SNFViewController.h"
#import "NSTimer+Blocks.h"
#import "SNFSyncService.h"

NSString * const SNFInviteAccepted = @"SNFInviteAccepted";

@interface SNFAcceptInvite ()
@property SNFUserService * service;
@end

@implementation SNFAcceptInvite

- (void) viewDidLoad {
	[super viewDidLoad];
	
	if([SNFModel sharedInstance].pendingInviteCode) {
		self.inviteCodeField.text = [SNFModel sharedInstance].pendingInviteCode;
	}
	
	if(self.invite) {
		self.inviteCodeField.text = self.invite.code;
		//self.joinLabel.text = [NSString stringWithFormat:@"Would you like to join the board %@?", self.invite.board_title];
	}
	
	if(self.inviteCode) {
		self.inviteCodeField.text = self.inviteCode;
	}
}

- (IBAction) joinBoard:(id) sender {
	self.service = [[SNFUserService alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service acceptInviteCode:self.inviteCodeField.text andCompletion:^(NSError *error, NSDictionary * data) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Invitation Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		if(data[@"invite"]) {
			//if invite was in response, load it into core data.
			self.invite = (SNFInvite *)[SNFInvite editOrCreatefromInfoDictionary:data[@"invite"] withContext:[SNFModel sharedInstance].managedObjectContext];
		}
		
		if(self.invite) {
			self.invite.accepted = @(TRUE);
			[[SNFModel sharedInstance].managedObjectContext save:nil];
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:SNFInviteAccepted object:self];
		
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[[SNFSyncService instance] updateLocalDataWithResults:data andCallCompletion:^(NSError *error, NSObject *boardData) {
			
			if(error) {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Invitation Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
				[self presentViewController:alert animated:TRUE completion:nil];
				return;
			}
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
				if(![SNFViewController instance]) {
					SNFViewController * root = [[SNFViewController alloc] init];
					root.firstTab = SNFTabBoards;
					[AppDelegate instance].window.rootViewController = root;
				} else {
					[[SNFViewController instance] showBoardsAnimated:TRUE];
				}
			}];
			
		}];
	}];
}

- (IBAction) cancel:(id) sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
