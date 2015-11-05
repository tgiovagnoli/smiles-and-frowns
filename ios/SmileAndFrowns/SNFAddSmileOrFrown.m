#import "SNFAddSmileOrFrown.h"
#import "SNFModel.h"

@implementation SNFAddSmileOrFrown


- (void)viewDidLoad{
	[super viewDidLoad];
	[self updateUI];
}

- (void)updateUI{
	self.amountField.text = [NSString stringWithFormat:@"%.0f", self.amountStepper.value];
	[self reloadBehaviors];
	
	switch(self.type){
		case SNFAddSmileOrFrownTypeFrown:
			[self.addSNFButton setTitle:@"Add Frown" forState:UIControlStateNormal];
			break;
		case SNFAddSmileOrFrownTypeSmile:
			[self.addSNFButton setTitle:@"Add Smile" forState:UIControlStateNormal];
			break;
	}
}

- (void)reloadBehaviors{
	_behaviors = [self.board sortedActiveBehaviors];
	[self.behaviorsTable reloadData];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI];
}

- (void)setType:(SNFAddSmileOrFrownType)type{
	_type = type;
	[self updateUI];
}

- (IBAction)onAddBehavior:(UIButton *)sender{
	SNFAddBehavior *addBehavior = [[SNFAddBehavior alloc] init];
	addBehavior.board = self.board;
	addBehavior.delegate = self;
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
	NSDictionary *smileDictionary = @{
									   @"note": self.noteField.text,
									   @"board": @{@"uuid": self.board.uuid},
									   @"behavior": @{@"uuid": behavior.uuid},
									   @"user": [self.user infoDictionary],
									  };
	[SNFSmile editOrCreatefromInfoDictionary:smileDictionary withContext:[SNFModel sharedInstance].managedObjectContext];
}

- (void)addFrownForBehavior:(SNFBehavior *)behavior{
	NSDictionary *frownDictionary = @{
									  @"note": self.noteField.text,
									  @"board": @{@"uuid": self.board.uuid},
									  @"behavior": @{@"uuid": behavior.uuid},
									  @"user": [self.user infoDictionary],
									  };
	[SNFFrown editOrCreatefromInfoDictionary:frownDictionary withContext:[SNFModel sharedInstance].managedObjectContext];
}

- (IBAction)onCancel:(UIButton *)sender{
	if(self.delegate){
		[self.delegate addSmileOrFrownFinished:self];
	}
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
	behavior.deleted = @YES;
	[self reloadBehaviors];
}

@end
