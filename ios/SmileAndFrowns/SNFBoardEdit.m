
#import "SNFBoardEdit.h"
#import "SNFModel.h"
#import "UIAlertAction+Additions.h"


@implementation SNFBoardEdit

- (void) viewDidLoad {
	[super viewDidLoad];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	// save the context in it's current state so that we can remove any objects that are used during editing here:
	NSError *error;
	[[SNFModel sharedInstance].managedObjectContext save:&error];
	if(error){
		NSLog(@"%@", error);
	}
	[self updateUI];
}

- (void)updateUI{
	self.boardTitleField.text = self.board.title;
	[self reloadBehaviors];
}

- (void)reloadBehaviors{
	_sortedBehaviors = [self.board sortedActiveBehaviors];
	[self.behaviorsTable reloadData];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField == self.boardTitleField){
		[textField resignFirstResponder];
		return NO;
	}
	return YES;
}

// behaviors
- (IBAction)onAddBehavior:(UIButton *)sender{
	SNFAddBehavior *addBehavior = [[SNFAddBehavior alloc] init];
	[self presentViewController:addBehavior animated:YES completion:^{}];
	addBehavior.board = self.board;
	addBehavior.delegate = self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView == self.behaviorsTable){
		return _sortedBehaviors.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == self.behaviorsTable){
		SNFBehavior *behavior = [_sortedBehaviors objectAtIndex:indexPath.row];
		SNFBoardEditBehaviorCell *cell = [self.behaviorsTable dequeueReusableCellWithIdentifier:@"SNFBoardEditBehaviorCell"];
		if(!cell){
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardEditBehaviorCell" owner:self options:nil];
			cell = [topLevelObjects firstObject];
		}
		cell.behavior = behavior;
		cell.delegate = self;
		return cell;
	}
	return nil;
}

- (void)behaviorCell:(SNFBoardEditBehaviorCell *)cell wantsToDeleteBehavior:(SNFBehavior *)behavior{
	behavior.deleted = @YES;
	[self reloadBehaviors];
}

- (void)addBehavior:(SNFAddBehavior *)addBehavior addedBehaviors:(NSArray *)behaviors toBoard:(SNFBoard *)board{
	[self reloadBehaviors];
}

- (void)addBehaviorCancelled:(SNFAddBehavior *)addBehavior{
	[self reloadBehaviors];
}

// rewards
- (IBAction)onUpdateBoard:(UIButton *)sender{
	if([self.boardTitleField.text isEmpty]){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must set a title for this board" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:YES completion:^{}];
		return;
	}
	_board.title = self.boardTitleField.text;
	[[SNFModel sharedInstance].managedObjectContext undo];
	[self dismissViewControllerAnimated:YES completion:^{}];
	if(self.delegate){
		[self.delegate boardEditor:self finishedWithBoard:self.board];
	}
}

- (IBAction)onCancel:(UIButton *)sender{
	[[SNFModel sharedInstance].managedObjectContext undo];
	[self dismissViewControllerAnimated:YES completion:^{}];
	if(self.delegate){
		[self.delegate boardEditor:self finishedWithBoard:self.board];
	}
}

@end
