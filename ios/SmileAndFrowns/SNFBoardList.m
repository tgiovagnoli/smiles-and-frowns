#import "SNFBoardList.h"
#import "SNFModel.h"
#import "SNFBoardListCell.h"
#import "SNFBoardDetail.h"
#import "SNFViewController.h"

@implementation SNFBoardList


- (void)viewDidLoad{
	[super viewDidLoad];
	[self reloadBoards];
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
	request.predicate = [NSPredicate predicateWithFormat:@"deleted == 0"];
	if(self.filter == SNFBoardListFilterDate){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"created_date" ascending:YES]];
	}else if(self.filter == SNFBoardListFilterName){
		request.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"title" ascending:YES]];
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

@end
