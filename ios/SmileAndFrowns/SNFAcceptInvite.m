
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFUserService.h"
#import "SNFViewController.h"
#import "NSTimer+Blocks.h"
#import "SNFSyncService.h"
#import "UIViewController+Alerts.h"
#import "SNFBoardDetail.h"

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
	
	if(self.inviteCode) {
		self.inviteCodeField.text = self.inviteCode;
	}
	
	[SNFFormStyles roundEdgesOnButton:self.joinButton];
	
	[self startBannerAd];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.joinButton];
}

- (IBAction) joinBoard:(id) sender {
	self.service = [[SNFUserService alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service acceptInviteCode:self.inviteCodeField.text andCompletion:^(NSError *error, NSDictionary * data) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Invitation Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		[[NSNotificationCenter defaultCenter] postNotificationName:SNFInviteAccepted object:self];
		
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[[SNFSyncService instance] updateLocalDataWithResults:data andCallCompletion:^(NSError *error, NSObject *boardData) {
			
			if(error) {
				[self displayOKAlertWithTitle:@"Invitation Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			[SNFModel sharedInstance].pendingInviteCode = nil;
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
				
				if(![SNFViewController instance]) {
					SNFViewController * root = [[SNFViewController alloc] init];
					root.firstTab = SNFTabBoards;
					[AppDelegate instance].window.rootViewController = root;
				} else {
					[[SNFViewController instance] showBoardsAnimated:TRUE];
				}
				
				//go to board detail if possible
				if([SNFViewController instance]) {
					if([data isKindOfClass:[NSDictionary class]]) {
						NSDictionary * boardData = (NSDictionary *)data;
						NSDictionary * invite = boardData[@"invite"];
						NSString * boardUUID = invite[@"board_uuid"];
						SNFBoard * board = [SNFBoard boardByUUID:boardUUID];
						SNFBoardDetail * detail = [[SNFBoardDetail alloc] init];
						detail.board = board;
						[[SNFViewController instance].viewControllerStack pushViewController:detail animated:TRUE];
					}
				}
				
			}];
			
		}];
	}];
}

- (IBAction) cancel:(id) sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
	[SNFModel sharedInstance].pendingInviteCode = nil;
}

@end
