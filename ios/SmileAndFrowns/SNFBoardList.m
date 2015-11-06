
#import "SNFBoardList.h"
#import "SNFModel.h"
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "IAPHelper.h"

@implementation SNFBoardList

- (void)viewDidLoad{
	[super viewDidLoad];
	[self reloadBoards];
	self.searchField.hidden = YES;
	[self.searchField addTarget:self action:@selector(searchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (IBAction) purchase:(id)sender {
	IAPHelper * helper = [[IAPHelper alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[helper loadItunesProductsCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		NSString * product = [helper productIdForName:@"NewBoard"];
		NSLog(@"NewBoard product id: %@",product);
		
		[helper purchaseItunesProductId:product completion:^(NSError *error, SKPaymentTransaction *transaction) {
			
			if(error) {
				
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[self presentViewController:alert animated:TRUE completion:nil];
				
				return;
			}
			
			NSLog(@"transaction id: %@",transaction.transactionIdentifier);
			
		}];
		
	}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _boards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFBoardListCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFBoardListCell"];
	if(!cell) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardListCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	cell.board = [_boards objectAtIndex:indexPath.row];
	cell.delegate = self;
	return cell;
}

- (void)boardListCell:(SNFBoardListCell *)cell wantsToEditBoard:(SNFBoard *)board{
	SNFBoardEdit *boardEdit = [[SNFBoardEdit alloc] init];
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
	SNFBoardDetail *boardDetail = [[SNFBoardDetail alloc] init];
	[[SNFViewController instance].viewControllerStack pushViewController:boardDetail animated:YES];
	boardDetail.board = [_boards objectAtIndex:indexPath.row];
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
		[self.boardsTable reloadData];
	}
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

@end
