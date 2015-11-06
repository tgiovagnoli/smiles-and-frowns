
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
#import "SNFModel.h"

@interface SNFInvites ()
@property SNFUserService * service;
@property NSArray * invites;
@end

@implementation SNFInvites

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.service = [[SNFUserService alloc] init];
	
	self.segment.selectedSegmentIndex = 1;
	self.search.visible = FALSE;
	self.search.delegate = self;
	[self.search addTarget:self action:@selector(searchFieldChanged:) forControlEvents:UIControlEventEditingChanged];
	
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
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:TRUE];
	return YES;
}

- (void) onKeyboardShow:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	CGFloat bottom = keyboardFrameEnd.size.height;
	if([SNFViewController instance].bannerView.superview) {
		bottom -= 50;
	}
	self.tableViewBottom.constant = bottom - 50;
}

- (void) onKeyboardHide:(NSNotification *) notification {
	self.tableViewBottom.constant = 0;
}

- (void) searchFieldChanged:(UITextField *) searchField {
	[self reload];
}

- (IBAction) segmentChanged:(UISegmentedControl *) sender {
	[self reload];
}

- (IBAction) search:(id) sender {
	if([[self.searchButton titleForState:UIControlStateNormal] isEqualToString:@"Done"]) {
		self.search.text = @"";
		self.search.visible = FALSE;
		[self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
		self.segment.visible = TRUE;
		[self.view endEditing:TRUE];
	} else {
		[self.search becomeFirstResponder];
		self.search.visible = TRUE;
		[self.searchButton setTitle:@"Done" forState:UIControlStateNormal];
		self.segment.visible = FALSE;
	}
}

- (void) reload {
	NSError * error;
	NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SNFInvite"];
	
	if([self.search.text isEmpty]) {
		
	} else {
		request.predicate = [NSPredicate predicateWithFormat:@"(sender_first_name CONTAINS[cd] %@) || (sender_last_name CONTAINS[cd] %@)", self.search.text,self.search.text];
	}
	
	if(self.segment.selectedSegmentIndex == 0) {
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"sender_first_name" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
		
	} else {
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_date" ascending:NO]];
	}
	
	NSArray * results = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
	
	self.invites = results;
	
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
	formatter.dateFormat = @"MMMM dd, YYYY";
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	formatter.locale = [NSLocale currentLocale];
	cell.dateLabel.text = [formatter stringFromDate:invite.created_date];
	
	if(invite.accepted.boolValue) {
		cell.titleLabel.textColor = [UIColor grayColor];
		cell.dateLabel.textColor = [UIColor grayColor];
	}
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	SNFInvite * invite = [self.invites objectAtIndex:indexPath.row];
	
	if(invite.accepted.boolValue) {
		
		BOOL showError = TRUE;
		
		if(invite.board_uuid) {
			
			SNFBoard * board = [SNFBoard boardByUUID:invite.board_uuid];
			
			if(board) {
				showError = FALSE;
				SNFBoardDetail * detail = [[SNFBoardDetail alloc] init];
				detail.board = board;
				[[SNFViewController instance].viewControllerStack pushViewController:detail animated:TRUE];
				
			}
		}
		
		if(showError) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"Board Not Found" preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
		}
		
		return;
	}
	
	UIView * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	SNFAcceptInvite * acceptor = [[SNFAcceptInvite alloc] initWithSourceView:cell sourceRect:CGRectZero contentSize:CGSizeMake(300,220)];
	acceptor.invite = invite;
	
	[[AppDelegate rootViewController] presentViewController:acceptor animated:TRUE completion:nil];
}

@end
