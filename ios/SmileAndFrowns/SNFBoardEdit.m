#import "SNFBoardEdit.h"
#import "SNFModel.h"

@implementation SNFBoardEdit

- (void)viewDidLoad{
	
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
	
}

// rewards
- (IBAction)onUpdateBoard:(UIButton *)sender{
	if([self.boardTitleField.text isEmpty]){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must set a title for this board" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
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
