
#import "SNFBoardList.h"
#import "SNFModel.h"
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "SNFSyncService.h"
#import "NSTimer+Blocks.h"

@implementation SNFBoardList

- (void)viewDidLoad{
	[super viewDidLoad];
	
	self.searchField.hidden = YES;
	[self.searchField addTarget:self action:@selector(searchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
	
	UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
	[refreshControl addTarget:self action:@selector(onBoardRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.boardsTable addSubview:refreshControl];
	[self.boardsTable insertSubview:refreshControl atIndex:0];
	
	[self reloadBoards];
}

- (void)onBoardRefresh:(UIRefreshControl *)refresh{
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		[refresh endRefreshing];
		if(error){
			NSLog(@"Error syncing");
		}else{
			[self reloadBoards];
		}
	}];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(section == SNFBoardListSectionBoards){
		return _boards.count;
	}else if(section == SNFBoardListSectionPredefinedBoards){
		return _predefinedBoards.count + 1;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.section == SNFBoardListSectionBoards){
		SNFBoardListCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFBoardListCell"];
		if(!cell){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"SNFBoardListCell" owner:nil options:nil] firstObject];
		}
		cell.board = [_boards objectAtIndex:indexPath.row];
		cell.delegate = self;
		return cell;
	}else if(indexPath.section == SNFBoardListSectionPredefinedBoards){
		SNFPredefinedBoardCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFPredefinedBoardCell"];
		if(!cell){
			cell = [[[NSBundle mainBundle] loadNibNamed:@"SNFPredefinedBoardCell" owner:nil options:nil] firstObject];
		}
		SNFPredefinedBoard *pdb;
		if(indexPath.row < _predefinedBoards.count){
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
		boardEdit = [[SNFBoardEdit alloc] initWithSourceView:cell.editButton sourceRect:CGRectZero contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionRight];
	} else {
		boardEdit = [[SNFBoardEdit alloc] initWithSourceView:cell.editButton sourceRect:CGRectZero contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionUp];
	}
	boardEdit.delegate = self;
	[[AppDelegate rootViewController] presentViewController:boardEdit animated:YES completion:^{}];
	boardEdit.board = board;
}

- (void)boardListCell:(SNFBoardListCell *)cell wantsToResetBoard:(SNFBoard *)board{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset board?" message:@"Are you sure you want to reset this board? All board data will be lost and this cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[board reset];
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
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFBoard"];
	if([self.searchField.text isEmpty]){
		request.predicate = [NSPredicate predicateWithFormat:@"(deleted == 0)", [SNFModel sharedInstance].loggedInUser.email];
	}else{
		request.predicate = [NSPredicate predicateWithFormat:@"(deleted == 0) && (title CONTAINS[cd] %@)", self.searchField.text,[SNFModel sharedInstance].loggedInUser.email];
	}
	
	if(self.filter == SNFBoardListFilterDate){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_date" ascending:NO]];
	}else if(self.filter == SNFBoardListFilterName){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)]];
	}
	
	NSArray *results = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
	if(error){
		NSLog(@"error loading boards");
	}else{
		NSMutableArray *permittedResults = [[NSMutableArray alloc] init];
		for(SNFBoard *board in results){
			if([self hasPermissionForBoard:board]){
				[permittedResults addObject:board];
			}
		}
		_boards = permittedResults;
	}
	
	// load up all the predefined boards
	_predefinedBoards = [SNFPredefinedBoard allObjectsWithContext:[SNFModel sharedInstance].managedObjectContext];
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
	NSLog(@"title - %@", board.title);
	for(SNFUserRole *userRole in board.user_roles){
		NSLog(@"email - %@ username - %@", userRole.user.email, userRole.user.username);
		if([userRole.user.email isEqualToString:authedUser.email]){
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
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		if(!error && user){
			NSArray *allBoards = [SNFBoard allObjectsWithContext:[SNFModel sharedInstance].managedObjectContext];
			BOOL needsPurchase = NO;
			NSString *loggedInUserName = [SNFModel sharedInstance].loggedInUser.username;
			for(SNFBoard *board in allBoards){
				if([board.owner.username isEqualToString:loggedInUserName]){
					needsPurchase = YES;
				}
			}
			if(needsPurchase && pdb){
				// buy board confirm
				NSString *messageString = [NSString stringWithFormat:@"\"%@\" %@. Would you like to purchase \"%@\"?", pdb.title, [self behaviorsStringFromBoard:pdb], pdb.title];
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[self purchaseNewBoard:pdb];
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}else if(!needsPurchase && pdb){
				// free board confirm
				NSString *messageString = [NSString stringWithFormat:@"\"%@\" %@. Are you sure you want to use \"%@\" as your free board?", pdb.title, [self behaviorsStringFromBoard:pdb], pdb.title];
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					[self addNewBoard:pdb withTransactionID:nil];
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}else{
				// empty board
				NSString *messageString = @"This will create an empty board.  You will need to add behaviors to this board before using it.  Continue?";
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					if(needsPurchase){
						[self purchaseNewBoard:pdb];
					}else{
						[self addNewBoard:pdb withTransactionID:nil];
					}
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}
		}else{
			if([error.localizedDescription isEqualToString:@"login required"]){
				// not authed
				NSString *messageString = @"You are currently not signed into smiles and frowns.  You need to login and be online to create a board.";
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}else{
				// likely offline
				NSString *messageString = @"It appears you are offline. Please make sure you are online and logged in to purchase a new board.";
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:messageString preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			}
		}
	}];
}

- (NSString *)behaviorsStringFromBoard:(SNFPredefinedBoard *)pdb{
	NSInteger i=0;
	NSMutableString *behaviors = [[NSMutableString alloc] init];
	NSInteger max = pdb.behaviors.count;
	if(max > 3){
		max = 3;
	}
	if(max == 0){
		return @"includes no behaviors";
	}
	if(max == 1){
		return [NSString stringWithFormat:@"includes the behavior %@", [[[pdb.behaviors allObjects] firstObject] title]];
	}
	[behaviors appendString:@"includes behaviors like "];
	for(SNFBehavior *pdBehavior in pdb.behaviors){
		if(i < max - 1){
			[behaviors appendFormat:@"%@, ", pdBehavior.title];
		}else{
			[behaviors appendFormat:@"and %@", pdBehavior.title];
		}
		i++;
		if(i > max){
			break;
		}
	}
	return behaviors;
}


- (void) purchaseNewBoard:(SNFPredefinedBoard *) pdb {
	
	#if TARGET_IPHONE_SIMULATOR
	[self addNewBoard:pdb withTransactionID:[[NSUUID UUID] UUIDString]];
	return;
	#endif
	
	IAPHelper * helper = [IAPHelper defaultHelper];
	
	NSArray * productIds = [helper productIdsByNames:@[@"NewBoard"]];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[helper loadItunesProducts:productIds withCompletion:^(NSError *error) {
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
			return;
		}
		
		NSString * product = [helper productIdByName:@"NewBoard"];
		NSLog(@"NewBoard product id: %@", product);
		
		[helper purchaseItunesProductId:product completion:^(NSError *error, SKPaymentTransaction *transaction) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
				return;
			}
			
			[NSTimer scheduledTimerWithTimeInterval:.25 block:^{
				[self addNewBoard:pdb withTransactionID:transaction.transactionIdentifier];
			} repeats:FALSE];
		}];
	}];
}

- (void) addNewBoard:(SNFPredefinedBoard *) pdb withTransactionID:(NSString *) transactionId {
	SNFBoard * newBoard = [SNFBoard boardFromPredefinedBoard:pdb andContext:[SNFModel sharedInstance].managedObjectContext];
	if(transactionId) {
		newBoard.transaction_id = transactionId;
	}
	[self reloadBoards];
	
	SNFBoardDetail * boardDetail = [[SNFBoardDetail alloc] init];
	[[SNFViewController instance].viewControllerStack pushViewController:boardDetail animated:YES];
	boardDetail.board = newBoard;
	
	[self boardListCell:nil wantsToEditBoard:newBoard];
}


- (IBAction)onPurchaseNewBoard:(id)sender{
	[self buyOrCreateBoard:nil];
}


@end
