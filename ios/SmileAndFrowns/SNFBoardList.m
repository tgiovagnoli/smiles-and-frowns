#import "SNFBoardList.h"
#import "SNFModel.h"
#import "SNFBoardListCell.h"
#import "SNFBoardDetail.h"
#import "SNFViewController.h"

@implementation SNFBoardList

- (void)viewDidLoad{
	[super viewDidLoad];
	[self reloadBoards];
	self.searchField.hidden = YES;
	[self.searchField addTarget:self action:@selector(searchFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _boards.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFBoardListCell *cell = [self.boardsTable dequeueReusableCellWithIdentifier:@"SNFBoardListCell"];
	if(!cell){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardListCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	cell.board = [_boards objectAtIndex:indexPath.row];
	return cell;
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
		request.predicate = [NSPredicate predicateWithFormat:@"deleted == 0"];
	}else{
		request.predicate = [NSPredicate predicateWithFormat:@"(deleted == 0) && (title CONTAINS[cd] %@)", self.searchField.text];
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
		_boards = results;
		[self.boardsTable reloadData];
	}
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

- (void)showSearch{
	[self.searchButton setTitle:@"Done" forState:UIControlStateNormal];
	self.searchField.hidden = NO;
	self.filterControl.hidden = YES;
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
