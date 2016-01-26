
#import "SNFInvites.h"
#import "SNFUserService.h"
#import "UIAlertAction+Additions.h"
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
#import "NSTimer+Blocks.h"
#import "SNFBoardDetailHeader.h"

@interface SNFInvites ()
@property SNFUserService * service;
@property NSArray * receivedInvites;
@property NSArray * sentInvites;
@property NSMutableArray * filteredReceivedInvites;
@property NSMutableArray * filteredSentInvites;
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
	[self reloadDataFirst];
	
	UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(onInviteRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.tableView addSubview:refreshControl];
	[self.tableView insertSubview:refreshControl atIndex:0];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteAccepted:) name:SNFInviteAccepted object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInviteDelete:) name:SNFInvitesCellDelete object:nil];
	
	[[GATracking instance] trackScreenWithTagManager:@"InvitesView"];
	
	[self decorate];
	
	[self startInterstitialAd];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.searchButton];
	[SNFFormStyles roundEdgesOnButton:self.inviteButton];
	[SNFFormStyles updateFontOnSegmentControl:self.segment];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onInviteRefresh:(UIRefreshControl *) refresh {
	[self.service invitesWithCompletion:^(NSError * error, NSArray * receivedInvites, NSArray * sentInvites) {
		[refresh endRefreshing];
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			}
		} else {
			[[UIApplication sharedApplication] setApplicationIconBadgeNumber:receivedInvites.count];
			self.receivedInvites = receivedInvites;
			self.sentInvites = sentInvites;
			[self reload];
		}
	}];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (BOOL) textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:TRUE];
	return YES;
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

- (NSString *) stringFromDate:(NSDate *) date {
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter stringFromDate:date];
}

- (NSDate *) dateFromString:(NSString *) dateString {
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	// 2015-10-21T21:34:54Z
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter dateFromString:dateString];
}

- (void) reloadDataFirst {
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	[self.service invitesWithCompletion:^(NSError *error, NSArray *receivedInvites, NSArray *sentInvites) {
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			}
			return;
		}
		
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:receivedInvites.count];
		self.receivedInvites = receivedInvites;
		self.sentInvites = sentInvites;
		[self reload];
	}];
}

- (void) reload {
	
	//filter received invites first based on search field
	self.filteredReceivedInvites = [NSMutableArray array];
	
	for(NSDictionary * invite in self.receivedInvites) {
		NSString * firstname = invite[@"invitee_firstname"];
		NSString * lastname = invite[@"invitee_lastname"];
		NSString * board_title = invite[@"board_title"];
		
		if(![self.search.text isEmpty]) {
			if((id)firstname != [NSNull null] && [firstname rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredReceivedInvites addObject:invite];
			} else if((id)lastname != [NSNull null] && [lastname rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredReceivedInvites addObject:invite];
			} else if((id)board_title != [NSNull null] && [board_title rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredReceivedInvites addObject:invite];
			}
		} else {
			[self.filteredReceivedInvites addObject:invite];
		}
	}
	
	//filter sent invites first based on search field
	self.filteredSentInvites = [NSMutableArray array];
	for(NSDictionary * invite in self.sentInvites) {
		NSString * firstname = invite[@"invitee_firstname"];
		NSString * lastname = invite[@"invitee_lastname"];
		NSString * board_title = invite[@"board_title"];
		
		if(![self.search.text isEmpty]) {
			if((id)firstname != [NSNull null] && [firstname rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredSentInvites addObject:invite];
			} else if((id)lastname != [NSNull null] && [lastname rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredSentInvites addObject:invite];
			} else if((id)board_title != [NSNull null] && [board_title rangeOfString:self.search.text].location != NSNotFound) {
				[self.filteredSentInvites addObject:invite];
			}
		} else {
			[self.filteredSentInvites addObject:invite];
		}
	}
	
	//sort the filtered arrays based to segment selection.
	
	[self.filteredReceivedInvites sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		
		NSDictionary * invite1 = (NSDictionary *) obj1;
		NSDictionary * invite2 = (NSDictionary *) obj2;
		NSDate * createdDate1 = [self dateFromString:invite1[@"created_date"]];
		NSDate * createdDate2 = [self dateFromString:invite2[@"created_date"]];
		NSString * firstname1 = invite1[@"invitee_firstname"];
		NSString * firstname2 = invite2[@"invitee_firstname"];
		
		if(self.segment.selectedSegmentIndex == 0) {
			return [firstname1 compare:firstname2 options:NSCaseInsensitiveSearch];
		} else {
			NSComparisonResult result = [createdDate1 compare:createdDate2];
			if(result == NSOrderedAscending) {
				return NSOrderedDescending;
			}
			if(result == NSOrderedDescending) {
				return NSOrderedAscending;
			}
		}
		
		return NSOrderedSame;
	}];
	
	[self.filteredSentInvites sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		
		NSDictionary * invite1 = (NSDictionary *) obj1;
		NSDictionary * invite2 = (NSDictionary *) obj2;
		NSDate * createdDate1 = [self dateFromString:invite1[@"created_date"]];
		NSDate * createdDate2 = [self dateFromString:invite2[@"created_date"]];
		NSString * firstname1 = invite1[@"invitee_firstname"];
		NSString * firstname2 = invite2[@"invitee_firstname"];
		
		if(self.segment.selectedSegmentIndex == 0) {
			return [firstname1 compare:firstname2 options:NSCaseInsensitiveSearch];
		} else {
			NSComparisonResult result = [createdDate1 compare:createdDate2];
			if(result == NSOrderedAscending) {
				return NSOrderedDescending;
			}
			if(result == NSOrderedDescending) {
				return NSOrderedAscending;
			}
		}
		
		return NSOrderedSame;
	}];
	
	[self.tableView reloadData];
}

- (void) onInviteAccepted:(NSNotification *) note {
	[self reloadDataFirst];
}

- (void) onInviteDelete:(NSNotification *) note {
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	[self.service deleteInviteCode:[note.userInfo objectForKey:@"code"] andCompletion:^(NSError *error) {
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			}
			return;
		}
		[self reloadDataFirst];
	}];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
	return 2;
}

- (CGFloat)tableView:(UITableView *) tableView heightForHeaderInSection:(NSInteger) section {
	if(section == SNFInvitesSectionReceived &&  self.filteredReceivedInvites.count < 1) {
		return 0;
	}
	
	if(section == SNFInvitesSectionSent && self.filteredSentInvites.count < 1) {
		return 0;
	}
	
	return 28;
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {
	SNFBoardDetailHeader * headerCell = [[SNFBoardDetailHeader alloc] init];
	
	if(section == SNFInvitesSectionReceived) {
		headerCell.textLabel.text = @"Received Invites";
	}
	
	if(section == SNFInvitesSectionSent) {
		headerCell.textLabel.text = @"Sent Invites";
	}
	
	return headerCell;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == SNFInvitesSectionReceived) {
		return self.filteredReceivedInvites.count;
	}
	
	if (section == SNFInvitesSectionSent) {
		return self.filteredSentInvites.count;
	}
	
	return 0;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSDictionary * invite = nil;
	
	if(indexPath.section == SNFInvitesSectionReceived) {
		invite = [self.filteredReceivedInvites objectAtIndex:indexPath.row];
	}
	
	if(indexPath.section == SNFInvitesSectionSent) {
		invite = [self.filteredSentInvites objectAtIndex:indexPath.row];
	}
	
	SNFInvitesCell * cell = [tableView dequeueReusableCellWithIdentifier:@"SNFInvites"];
	
	if(!cell) {
		NSArray * nib = [[NSBundle mainBundle] loadNibNamed:@"SNFInvitesCell" owner:nil options:nil];
		cell = [nib objectAtIndex:0];
	}
	
	if(indexPath.section == SNFInvitesSectionReceived) {
		cell.titleLabel.text = [NSString stringWithFormat:@"%@ invited you to %@", invite[@"sender_first_name"], invite[@"board_title"]];
	} else {
		cell.titleLabel.text = [NSString stringWithFormat:@"You invited %@ to %@", invite[@"invitee_firstname"], invite[@"board_title"]];
	}
	
	cell.selectionStyle = UITableViewCellSelectionStyleNone;
	
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	formatter.dateFormat = @"MMMM dd, YYYY";
	[formatter setTimeZone:[NSTimeZone localTimeZone]];
	formatter.locale = [NSLocale currentLocale];
	
	NSDate * date = [self dateFromString:invite[@"created_date"]];
	
	cell.dateLabel.text = [formatter stringFromDate:date];
	cell.inviteCode = invite[@"code"];
	
	return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *) indexPath {
	if(indexPath.section == SNFInvitesSectionSent) {
		return;
	}
	
	NSDictionary * invite = [self.filteredReceivedInvites objectAtIndex:indexPath.row];
	UIView * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	
	SNFAcceptInvite * acceptor = [[SNFAcceptInvite alloc] initWithSourceView:cell sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
	acceptor.inviteCode = invite[@"code"];
	
	[[AppDelegate rootViewController] presentViewController:acceptor animated:TRUE completion:nil];
}

- (IBAction) enterInviteCode:(id)sender {
	SNFAcceptInvite * accept = [[SNFAcceptInvite alloc] initWithSourceView:self.inviteButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190) arrowDirections:UIPopoverArrowDirectionDown];
	[[AppDelegate rootViewController] presentViewController:accept animated:TRUE completion:nil];
}

@end
