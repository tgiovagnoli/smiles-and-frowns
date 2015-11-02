
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
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView == self.behaviorsTable){
		return _board.behaviors.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == self.behaviorsTable){
		NSArray *behaviorsArray = [_board.behaviors allObjects];
		SNFBehavior *behavior = [behaviorsArray objectAtIndex:indexPath.row];
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
	[self.board removeBehaviorsObject:behavior];
	behavior.deleted = @YES;
	[self.behaviorsTable reloadData];
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
