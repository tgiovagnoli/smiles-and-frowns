
#import "SNFInvites.h"
#import "SNFUserService.h"
#import "UIAlertAction+Additions.h"
#import "SNFInvite.h"
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "UIViewController+Alerts.h"
#import "UIView+LayoutHelpers.h"
#import "UIViewController+ModalCreation.h"
#import "SNFBoard.h"
#import "SNFViewController.h"
#import "SNFBoardDetail.h"
#import "SNFInvitesCell.h"

@interface SNFInvites ()
@property SNFUserService * service;
@property NSArray * invites;
@end

@implementation SNFInvites

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.service = [[SNFUserService alloc] init];
	self.tableView.delegate = self;
	self.tableView.dataSource = self;
	[self reload];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service invitesWithCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
		} else {
			[self reload];
		}
	}];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteAccepted:) name:SNFInviteAccepted object:nil];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (void) reload {
	self.invites = [SNFInvite all];
	[self.tableView reloadData];
}

- (void) onInviteAccepted:(NSNotification *) note {
	[self reload];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.invites.count;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	SNFInvite * invite = [self.invites objectAtIndex:indexPath.row];
	SNFInvitesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNFInvites"];
	
	if(!cell) {
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"SNFInvitesCell" owner:nil options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	cell.titleLabel.text = [NSString stringWithFormat:@"%@ invited you to %@", invite.sender_first_name, invite.board_title];
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MM dd, YYYY";
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	formatter.locale = [NSLocale currentLocale];
	cell.dateLabel.text = [formatter stringFromDate:invite.created_date];
	
	if(invite.accepted.boolValue) {
		cell.titleLabel.textColor = [UIColor grayColor];
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SNFInvite * invite = [self.invites objectAtIndex:indexPath.row];
	
	if(invite.accepted.boolValue) {
		
		if(invite.board_uuid) {
			SNFBoard * board = [SNFBoard boardByUUID:invite.board_uuid];
			SNFBoardDetail * detail = [[SNFBoardDetail alloc] init];
			detail.board = board;
			[[SNFViewController instance].viewControllerStack pushViewController:detail animated:TRUE];
			return;
		}
		
		//TODO: Lookup board and go to detail view.
		return;
	}
	
	UIView * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	SNFAcceptInvite * acceptor = [[SNFAcceptInvite alloc] initWithSourceView:cell sourceRect:CGRectZero contentSize:CGSizeMake(300,220)];
	acceptor.invite = invite;
	
	[[AppDelegate rootViewController] presentViewController:acceptor animated:TRUE completion:nil];
}

@end
