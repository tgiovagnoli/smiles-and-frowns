
#import "SNFBoardList.h"
#import "SNFModel.h"
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "SNFSyncService.h"
#import "NSTimer+Blocks.h"
#import "SNFLauncher.h"

const NSString * SNFBoardListCustomTitle = @"Custom Board";

@implementation SNFBoardList

- (void) viewDidLoad {
	[super viewDidLoad];
	self.searchField.hidden = YES;
	[self.searchField addTarget:self action:@selector(searchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	UIRefreshControl * refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(onBoardRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.boardsTable addSubview:refreshControl];
	[self.boardsTable insertSubview:refreshControl atIndex:0];
	[self decorate];
	[self reloadBoards];
	
	[[GATracking instance] trackScreenWithTagManager:@"BoardListView"];
}

- (void) decorate {
	[SNFFormStyles roundEdgesOnButton:self.searchButton];
	[SNFFormStyles roundEdgesOnButton:self.purchaseButton];
	[SNFFormStyles updateFontOnSegmentControl:self.filterControl];
}

- (void) viewStack:(UIViewControllerStack *) viewStack willShowView:(UIViewControllerStackOperation) operation wasAnimated:(BOOL) wasAnimated {
	[self reloadBoards];
}

- (void) onBoardRefresh:(UIRefreshControl *) refresh {
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		[refresh endRefreshing];
		if(error) {
			if(error.code == -1009) {
				[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
			} else {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
			}
			
		} else {
			[self reloadBoards];
		}
	}];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *) viewStack {
	return TRUE;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView {
	return 2;
}

- (NSInteger) tableView:(UITableView *) tableView numberOfRowsInSection:(NSInteger) section {
	if(section == SNFBoardListSectionBoards) {
		return _boards.count;
	}
	
	else if(section == SNFBoardListSectionPredefinedBoards) {
		
		if([self showCustom]) {
			return _predefinedBoards.count + 1;
		} else {
			return _predefinedBoards.count;
		}
		
	}
	
	return 0;
}

- (BOOL) showCustom {
	return NO;
	//if([[SNFBoardListCustomTitle lowercaseString] containsString:[self.searchField.text lowercaseString]] || [self.searchField.text isEmpty]){
	//	return YES;
	//}
	//return NO;
}

- (UITableViewCell *) tableView:(UITableView *) tableView cellForRowAtIndexPath:(NSIndexPath *) indexPath {
	if(indexPath.section == SNFBoardListSectionBoards) {
		
		SNFBoardListCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFBoardListCell"];
		
		if(!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"SNFBoardListCell" owner:nil options:nil] firstObject];
		}
		
		cell.board = [_boards objectAtIndex:indexPath.row];
		cell.delegate = self;
		
		return cell;
		
	} else if(indexPath.section == SNFBoardListSectionPredefinedBoards) {
		SNFPredefinedBoardCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFPredefinedBoardCell"];
		if(!cell) {
			cell = [[[NSBundle mainBundle] loadNibNamed:@"SNFPredefinedBoardCell" owner:nil options:nil] firstObject];
		}
		
		SNFPredefinedBoard * pdb = nil;
		if(indexPath.row < _predefinedBoards.count) {
			pdb = [_predefinedBoards objectAtIndex:indexPath.row];
		}
		cell.predefinedBoard = pdb;
		
		return cell;
	}
	return nil;
}

- (void)boardListCell:(SNFBoardListCell *)cell wantsToEditBoard:(SNFBoard *)board{
	SNFBoardEdit * boardEdit = nil;
	if(cell) {
		boardEdit = [[SNFBoardEdit alloc] initWithSourceView:cell.editButton sourceRect:CGRectZero contentSize:CGSizeMake(500,644) arrowDirections:UIPopoverArrowDirectionRight];
	} else {
		boardEdit = [[SNFBoardEdit alloc] initWithSourceView:cell.editButton sourceRect:CGRectZero contentSize:CGSizeMake(500,644) arrowDirections:UIPopoverArrowDirectionUp];
	}
	boardEdit.delegate = self;
	[[AppDelegate rootViewController] presentViewController:boardEdit animated:YES completion:^{}];
	boardEdit.board = board;
}

- (void)boardListCell:(SNFBoardListCell *)cell wantsToResetBoard:(SNFBoard *)board{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset board?" message:@"Are you sure you want to reset this board? All data will be lost and participating users will be removed from this board. This cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		NSArray * predefinedBehaviors = [board predefinedBoardBehaviors];
		NSString * predefinedBoardUUID = board.predefined_board_uuid;
		[board reset];
		board.soft_deleted = @(TRUE);
		[self addNewBoard:nil withTransactionID:board.transaction_id editBoard:FALSE title:board.title copyBehaviors:predefinedBehaviors predefinedBoardUUID:predefinedBoardUUID];
		[[SNFSyncService instance] saveContext];
		[self reloadBoards];
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
	[self presentViewController:alert animated:YES completion:^{}];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == SNFBoardListSectionBoards){
		SNFBoardDetail *boardDetail = [[SNFBoardDetail alloc] init];
		[[SNFViewController instance].viewControllerStack pushViewController:boardDetail animated:YES];
		boardDetail.board = [_boards objectAtIndex:indexPath.row];
	}else if (indexPath.section == SNFBoardListSectionPredefinedBoards){
		SNFPredefinedBoard *pdb = nil;
		if(indexPath.row < _predefinedBoards.count){
			pdb = [_predefinedBoards objectAtIndex:indexPath.row];
		}
		[self buyOrCreateBoard:pdb];
	}
}

- (void)reloadBoards{
	NSError * error;
	NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SNFBoard"];
	if([self.searchField.text isEmpty]) {
		request.predicate = [NSPredicate predicateWithFormat:@"(soft_deleted == 0)", [SNFModel sharedInstance].loggedInUser.email];
	}else{
		request.predicate = [NSPredicate predicateWithFormat:@"(soft_deleted == 0) && (title CONTAINS[cd] %@)", self.searchField.text,[SNFModel sharedInstance].loggedInUser.email];
	}
	
	if(self.filter == SNFBoardListFilterDate){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_date" ascending:NO]];
	}else if(self.filter == SNFBoardListFilterName){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	}
	
	NSArray * results = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
	if(error) {
		NSLog(@"error loading boards");
	} else {
		NSMutableArray * permittedResults = [[NSMutableArray alloc] init];
		for(SNFBoard * board in results) {
			if([self hasPermissionForBoard:board]) {
				[permittedResults addObject:board];
			}
		}
		_boards = permittedResults;
	}
	
	//load up all the predefined boards
	NSFetchRequest * predefRequest = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBoard"];
	NSSortDescriptor * list_sort = [[NSSortDescriptor alloc] initWithKey:@"list_sort" ascending:TRUE];
	predefRequest.sortDescriptors = @[list_sort];
	
	if(![self.searchField.text isEmpty]) {
		predefRequest.predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@) && (soft_delete = 0)", self.searchField.text];
	} else {
		predefRequest.predicate = [NSPredicate predicateWithFormat:@"(soft_delete = 0)", self.searchField.text];
	}
	
	_predefinedBoards = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:predefRequest error:&error];
	
	if(!_predefinedBoards || _predefinedBoards.count < 1) {
		
		predefRequest.predicate = nil;
		
		if(![self.searchField.text isEmpty]) {
			predefRequest.predicate = [NSPredicate predicateWithFormat:@"(title CONTAINS[cd] %@)", self.searchField.text];
		}
		
		_predefinedBoards = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:predefRequest error:&error];
	}
	
	if(error) {
		NSLog(@"error loading predefined boards");
	}
	
	[self.boardsTable reloadData];
}

- (BOOL)hasPermissionForBoard:(SNFBoard *)board{
	SNFUser *authedUser = [SNFModel sharedInstance].loggedInUser;
	if(!authedUser){
		return NO;
	}
	if([board.owner.email isEqualToString:authedUser.email]){
		return YES;
	}
	for(SNFUserRole *userRole in board.user_roles){
		if([userRole.user.email isEqualToString:authedUser.email] && ![userRole.soft_deleted boolValue]){
			return YES;
		}
	}
	return NO;
}

- (IBAction)changeSorting:(UISegmentedControl *)sender{
	self.filter = sender.selectedSegmentIndex;
	[self reloadBoards];
}

- (IBAction)showSeachField:(UIButton *)sender{
	if(self.searchField.hidden){
		[self showSearch];
	}else{
		[self hideSearch];
	}
}

- (void)boardEditor:(SNFBoardEdit *)be finishedWithBoard:(SNFBoard *)board{
	[self reloadBoards];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 60;
}

- (void)showSearch{
	[self.searchButton setTitle:@"Done" forState:UIControlStateNormal];
	self.searchField.hidden = NO;
	self.filterControl.hidden = YES;
	[self.searchField becomeFirstResponder];
}

- (void)hideSearch{
	[self.searchField resignFirstResponder];
	[self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
	self.searchField.hidden = YES;
	self.filterControl.hidden = NO;
}

- (void)searchFieldDidChange:(UITextField *)searchfield{
	[self reloadBoards];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[self hideSearch];
	return NO;
}

- (void)buyOrCreateBoard:(SNFPredefinedBoard *)pdb{
	// make sure that the user is logged in
	SNFUserService * userService = [[SNFUserService alloc] init];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		if(!error && user) {
			NSArray * allBoards = [SNFBoard allObjectsWithContext:[SNFModel sharedInstance].managedObjectContext];
			BOOL needsPurchase = NO;
			
			NSString * loggedInUserName = [SNFModel sharedInstance].loggedInUser.username;
			for(SNFBoard * board in allBoards) {
				if([board.owner.username isEqualToString:loggedInUserName]) {
					needsPurchase = YES;
					break;
				}
			}
			
			if(needsPurchase && pdb) {
				// buy board confirm
				NSString *messageString = [self behaviorsStringFromBoard:pdb];
				messageString = [messageString stringByAppendingString:@" Would you like to buy this board?"];
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:pdb.title message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[self purchaseNewBoard:pdb];
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}
			
			else if(!needsPurchase && pdb) {
				// free board confirm
				NSString * messageString = [self behaviorsStringFromBoard:pdb];
				messageString = [messageString stringByAppendingString:@" Would you like to use this board?"];
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:pdb.title message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[self addNewBoard:pdb withTransactionID:nil editBoard:TRUE title:nil copyBehaviors:nil predefinedBoardUUID:nil];
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}
			
			else {
				// empty board
				if(needsPurchase) {
					[self purchaseNewBoard:pdb];
				} else {
					[self addNewBoard:pdb withTransactionID:nil editBoard:TRUE title:nil copyBehaviors:nil predefinedBoardUUID:nil];
				}
			}
			
		}
		
		else {
			if([error.localizedDescription isEqualToString:@"login required"]) {
				
				// not authed
				NSString * messageString = @"You are currently not signed into smiles and frowns. You need to login and be online to create a board.";
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[SNFModel sharedInstance].loggedInUser = nil;
					[AppDelegate instance].window.rootViewController = [[SNFLauncher alloc] init];
				}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
				
			}
			
			else {
				// likely offline
				NSString * messageString = @"It appears you are offline. Please make sure you are online and logged in to purchase a new board.";
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}
		}
	}];
}

- (NSString *) behaviorsStringFromBoard:(SNFPredefinedBoard *) pdb {
	
	if(pdb.board_description && ![pdb.board_description isEqual:[NSNull null]]) {
		return pdb.board_description;
	}
	
	NSInteger i = 0;
	NSMutableString *behaviors = [[NSMutableString alloc] init];
	NSInteger max = pdb.behaviors.count;
	
	if(max > 3) {
		max = 3;
	}
	
	if(max == 0) {
		return @"includes no behaviors";
	}
	
	if(max == 1) {
		return [NSString stringWithFormat:@"includes the behavior %@.", [[[pdb.behaviors allObjects] firstObject] title]];
	}
	
	[behaviors appendString:@"includes behaviors like "];
	
	for(SNFBehavior * pdBehavior in pdb.behaviors) {
		if(i < max - 1) {
			[behaviors appendFormat:@"%@, ", pdBehavior.title];
		} else {
			[behaviors appendFormat:@"and %@", pdBehavior.title];
		}
		
		i++;
		
		if(i >= max) {
			break;
		}
	}
	
	return behaviors;
}


- (void) purchaseNewBoard:(SNFPredefinedBoard *) pdb {
	
	#if TARGET_IPHONE_SIMULATOR
	[self addNewBoard:pdb withTransactionID:[[NSUUID UUID] UUIDString] editBoard:TRUE title:nil copyBehaviors:nil predefinedBoardUUID:nil];
	return;
	#endif
	
	NSArray * productIds = [[IAPHelper defaultHelper] productIdsByNames:@[@"NewBoard"]];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[[IAPHelper defaultHelper] loadItunesProducts:productIds withCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		NSString * product = [[IAPHelper defaultHelper] productIdByName:@"NewBoard"];
		NSLog(@"NewBoard product id: %@", product);
		
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[[IAPHelper defaultHelper] purchaseItunesProductId:product completion:^(NSError *error, SKPaymentTransaction *transaction) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			[NSTimer scheduledTimerWithTimeInterval:.25 block:^{
				[self addNewBoard:pdb withTransactionID:transaction.transactionIdentifier editBoard:TRUE title:nil copyBehaviors:nil predefinedBoardUUID:nil];
			} repeats:FALSE];
		}];
	}];
}

- (void) addNewBoard:(SNFPredefinedBoard *) pdb withTransactionID:(NSString *) transactionId editBoard:(BOOL) editBoard title:(NSString *) title copyBehaviors:(NSArray *) copyBehaviors predefinedBoardUUID:(NSString *) predefinedBoardUUID {
	SNFBoard * newBoard = [SNFBoard boardFromPredefinedBoard:pdb andContext:[SNFModel sharedInstance].managedObjectContext];
	
	if(pdb) {
		newBoard.predefined_board_uuid = pdb.uuid;
	} else if(predefinedBoardUUID) {
		newBoard.predefined_board_uuid = predefinedBoardUUID;
	}
	
	if(transactionId) {
		newBoard.transaction_id = transactionId;
	}
	
	if(title) {
		newBoard.title = title;
	}
	
	if(copyBehaviors) {
		for(SNFPredefinedBehavior * pdBehavior in copyBehaviors) {
			NSDictionary * behaviorInfo = @{
				@"title": pdBehavior.title,
				@"board": @{@"uuid":newBoard.uuid},
				@"positive": pdBehavior.positive,
				@"predefined_behavior_uuid":pdBehavior.uuid,
				@"group":pdBehavior.group,
			};
			SNFBehavior * behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:[SNFModel sharedInstance].managedObjectContext];
			behavior.predefined_behavior_uuid = pdBehavior.uuid;
		}
	}
	
	[[SNFSyncService instance] saveContext];
	
	[self reloadBoards];
	
	if(editBoard) {
		SNFBoardDetail * boardDetail = [[SNFBoardDetail alloc] init];
		[[SNFViewController instance].viewControllerStack pushViewController:boardDetail animated:YES];
		boardDetail.board = newBoard;
		[self boardListCell:nil wantsToEditBoard:newBoard];
	}
	
	//NSLog(@"\nboard updated:%@ \nlast synced:%@", newBoard.updated_date, [SNFModel sharedInstance].userSettings.lastSyncDate);
}


- (IBAction)onPurchaseNewBoard:(id)sender{
	[self buyOrCreateBoard:nil];
}


@end
