
#import "SNFInvites.h"
#import "SNFUserService.h"
#import "UIAlertAction+Additions.h"
#import "SNFInvite.h"
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "UIViewController+Alerts.h"
#import "UIView+LayoutHelpers.h"

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
	UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNFInvites"];
	if(!cell) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SNFInvites"];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"%@ invited you to %@", invite.sender_first_name, invite.board_title];
	if(invite.accepted.boolValue) {
		cell.textLabel.textColor = [UIColor grayColor];
	}
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SNFInvite * invite = [self.invites objectAtIndex:indexPath.row];
	if(invite.accepted.boolValue) {
		return;
	}
	SNFAcceptInvite * acceptor = [[SNFAcceptInvite alloc] init];
	acceptor.invite = invite;
	[[AppDelegate rootViewController] presentViewController:acceptor animated:TRUE completion:nil];
}

@end
