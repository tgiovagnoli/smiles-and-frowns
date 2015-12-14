
#import "SNFAddSmileOrFrown.h"
#import "SNFModel.h"
#import "UIViewController+ModalCreation.h"
#import "SNFSyncService.h"
#import "SNFFormStyles.h"

@implementation SNFAddSmileOrFrown


- (void)viewDidLoad{
	[super viewDidLoad];
	[self startBannerAd];
	[self updateUI:TRUE];
	
	_smileCountPicker = [[SNFValuePicker alloc] init];
	NSMutableArray *vals = [[NSMutableArray alloc] init];
	for(NSInteger i=1; i<101; i++) {
		[vals addObject:[NSString stringWithFormat:@"%lu", (long)i]];
	}
	_smileCountPicker.values = vals;
	_smileCountPicker.delegate = self;
	
	[self.amountFieldButton setTitle:@"" forState:UIControlStateNormal];
	
	self.noteField.layer.borderColor = [[SNFFormStyles darkSandColor] CGColor];
	self.noteField.layer.borderWidth = 1;
	
	[self decorate];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.addSNFButton];
	[SNFFormStyles roundEdgesOnButton:self.addBehaviorButton];
}

- (void) textViewDidBeginEditing:(UITextView *)textView {
	if(textView == self.noteField) {
		if([self.noteField.text isEqualToString:@"Add a note (Optional)"]) {
			textView.text = @"";
			textView.textColor = [SNFFormStyles darkGray];
		}
	}
}

- (void) textViewDidEndEditing:(UITextView *)textView {
	if(textView == self.noteField) {
		if([self.noteField.text isEmpty]) {
			textView.text = @"Add a note (Optional)";
			textView.textColor = [UIColor lightGrayColor];
		}
	}
}

- (void)updateUI:(BOOL) reloadBehaviors {
	self.amountField.text = [NSString stringWithFormat:@"%.0f", self.amountStepper.value];
	if(reloadBehaviors) {
		[self reloadBehaviors];
	}
	switch(self.type){
		case SNFAddSmileOrFrownTypeFrown:
			self.titleLabel.text = @"Give Frowns";
			[self.addSNFButton setTitle:@"Give Frown" forState:UIControlStateNormal];
			self.snfTypeImageView.image = [UIImage imageNamed:@"frown"];
			break;
		case SNFAddSmileOrFrownTypeSmile:
			self.titleLabel.text = @"Give Smiles";
			[self.addSNFButton setTitle:@"Give Smile" forState:UIControlStateNormal];
			self.snfTypeImageView.image = [UIImage imageNamed:@"smile"];
			break;
	}
}

- (void)reloadBehaviors{
	switch (self.type) {
		case SNFAddSmileOrFrownTypeSmile:
			_behaviors = [self.board sortedActivePositiveBehaviors];
			break;
		case SNFAddSmileOrFrownTypeFrown:
			_behaviors = [self.board sortedActiveNegativeBehaviors];
			break;
	}
	[self.behaviorsTable reloadData];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI:TRUE];
}

- (void)setType:(SNFAddSmileOrFrownType)type{
	_type = type;
	[self updateUI:TRUE];
	
	if(type == SNFAddSmileOrFrownTypeFrown) {
		[[GATracking instance] trackScreenWithTagManager:@"GiveFrownView"];
	} else {
		[[GATracking instance] trackScreenWithTagManager:@"GiveSmileView"];
	}
	
}

- (IBAction)onAddBehavior:(UIButton *)sender{
	SNFAddBehavior *addBehavior = [[SNFAddBehavior alloc] initWithSourceView:sender sourceRect:CGRectZero contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
	addBehavior.board = self.board;
	addBehavior.delegate = self;
	if(self.type == SNFAddSmileOrFrownTypeFrown) {
		addBehavior.selectNegativeOnLoad = TRUE;
	}
	addBehavior.disableOppositeFilter = TRUE;
	[self presentViewController:addBehavior animated:YES completion:^{}];
}

- (void)addBehavior:(SNFAddBehavior *)addBehavior addedBehaviors:(NSArray *)behaviors toBoard:(SNFBoard *)board{
	[self reloadBehaviors];
}

- (void)addBehaviorCancelled:(SNFAddBehavior *)addBehavior{
	
}

- (IBAction)onAddSmileOrFrown:(UIButton *)sender{
	//SNFBehavior *behavior = self.
	NSIndexPath *indexPath = [self.behaviorsTable indexPathForSelectedRow];
	if(!indexPath){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must select a behavior to add a smile." preferredStyle:UIAlertControllerStyleAlert];
		if(self.type == SNFAddSmileOrFrownTypeFrown){
			alert.message = @"You must select a behavior to add a frown.";
		}
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:YES completion:^{}];
		return;
	}
	SNFBehavior *behavior = [_behaviors objectAtIndex:indexPath.row];
	for(NSInteger i=0; i<self.amountStepper.value; i++){
		switch(self.type){
			case SNFAddSmileOrFrownTypeFrown:
				[self addFrownForBehavior:behavior];
				break;
			case SNFAddSmileOrFrownTypeSmile:
				[self addSmileForBehavior:behavior];
				break;
		}
	}
	if(self.delegate){
		[self.delegate addSmileOrFrownFinished:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)addSmileForBehavior:(SNFBehavior *)behavior{
	if(![self validateAndWarnForBehavior:behavior]){
		return;
	}
	
	NSString * note = self.noteField.text;
	if([note isEqualToString:@"Add a note (Optional)"]) {
		note = @"";
	}
	
	NSDictionary *smileDictionary = @{
									   @"note": note,
									   @"board": @{@"uuid": self.board.uuid},
									   @"behavior": @{@"uuid": behavior.uuid},
									   @"user": [self.user infoDictionary],
									   @"creator": [[SNFModel sharedInstance].loggedInUser infoDictionary],
									  };
	[SNFSmile editOrCreatefromInfoDictionary:smileDictionary withContext:[SNFModel sharedInstance].managedObjectContext];
	[[SNFSyncService instance] saveContext];
}

- (void)addFrownForBehavior:(SNFBehavior *)behavior{
	if(![self validateAndWarnForBehavior:behavior]){
		return;
	}
	
	NSString * note = self.noteField.text;
	if([note isEqualToString:@"Add a note (Optional)"]) {
		note = @"";
	}
	
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSDictionary *frownDictionary = @{
									  @"note": note,
									  @"board": @{@"uuid": self.board.uuid},
									  @"behavior": @{@"uuid": behavior.uuid},
									  @"user": [self.user infoDictionary],
									  @"creator": [[SNFModel sharedInstance].loggedInUser infoDictionary],
									  };
	[SNFFrown editOrCreatefromInfoDictionary:frownDictionary withContext:context];
	[[SNFSyncService instance] saveContext];
}

- (BOOL)validateAndWarnForBehavior:(SNFBehavior *)behavior{
	if(!self.board.uuid || [self.board.uuid isEmpty]){
		[self errorAlertWithMessage:@"Something went wrong trying to create this smile.  The board does not exist."];
		return NO;
	}
	if(!behavior || !behavior.uuid || [behavior.uuid isEmpty]){
		[self errorAlertWithMessage:@"Something went wrong trying to create this smile.  The behavior does not exist."];
		return NO;
	}
	if(!self.user || !self.user.username || [self.user.username isEmpty]){
		[self errorAlertWithMessage:@"Something went wrong trying to create this smile.  The child does not exist."];
		return NO;
	}
	SNFUser *loggedInUser = [SNFModel sharedInstance].loggedInUser;
	if(!loggedInUser || !loggedInUser.username || [loggedInUser.username isEmpty]){
		[self errorAlertWithMessage:@"You must login to use this feature."];
		return NO;
	}
	return YES;
}

- (void)errorAlertWithMessage:(NSString *)message{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Erro" message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
	[self presentViewController:alert animated:YES completion:^{}];
}

- (IBAction)onCancel:(UIButton *)sender{
	//if(self.delegate){
	//	[self.delegate addSmileOrFrownFinished:self];
	//}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onSmileAmountUpdate:(UIStepper *)sender{
	self.amountField.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if(tableView == self.behaviorsTable){
		return _behaviors.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == self.behaviorsTable){
		SNFBehavior *behavior = [_behaviors objectAtIndex:indexPath.row];
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
	behavior.soft_deleted = @YES;
	[self reloadBehaviors];
}

- (IBAction)onChangeAmount:(UIButton *)sender{
	[self.view addSubview:_smileCountPicker.view];
	[_smileCountPicker.view  matchFrameSizeOfView:self.view];
	_smileCountPicker.selectedValue = [NSString stringWithFormat:@"%lu", (long)floor(self.amountStepper.value)];
}

- (void)valuePicker:(SNFValuePicker *)valuePicker changedValue:(NSString *)value{
	NSInteger newVal = [value integerValue];
	self.amountStepper.value = newVal;
	[self updateUI:FALSE];
}

- (void)valuePickerFinished:(SNFValuePicker *)valuePicker{
	[_smileCountPicker.view removeFromSuperview];
}

@end
