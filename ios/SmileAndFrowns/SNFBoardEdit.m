
#import "SNFBoardEdit.h"
#import "SNFModel.h"
#import "UIAlertAction+Additions.h"
#import "UIViewController+ModalCreation.h"

@implementation SNFBoardEdit

- (void) viewDidLoad {
	[super viewDidLoad];
	self.rewardInfoLabel.text = @" ";
	[self.rewardsCollectionView registerClass:[SNFRewardCell class] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollectionView registerNib:[UINib nibWithNibName:@"SNFRewardCell" bundle:nil] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollectionView registerClass:[SNFAddCell class] forCellWithReuseIdentifier:@"SNFAddCell"];
	[self.rewardsCollectionView registerNib:[UINib nibWithNibName:@"SNFAddCell" bundle:nil] forCellWithReuseIdentifier:@"SNFAddCell"];
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
	[self reloadRewards];
}

- (void) reloadBehaviors {
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
	SNFAddBehavior * addBehavior = [[SNFAddBehavior alloc] initWithSourceView:self.addBehaviorButton sourceRect:CGRectZero contentSize:CGSizeMake(500,600)];
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
- (void)reloadRewards{
	_sortedRewards = [self.board sortedActiveRewards];
	[self.rewardsCollectionView reloadData];
}

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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return _sortedRewards.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row == 0){
		SNFAddCell *addCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SNFAddCell" forIndexPath:indexPath];
		addCell.delegate = self;
		return addCell;
	}
	
	SNFRewardCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SNFRewardCell" forIndexPath:indexPath];
	SNFReward *reward = [_sortedRewards objectAtIndex:indexPath.row - 1];
	cell.reward = reward;
	return cell;
}

- (void)addCellWantsToAdd:(SNFAddCell *)addCell{
	SNFAddReward *addReward = [[SNFAddReward alloc] initWithSourceView:addCell sourceRect:CGRectZero contentSize:CGSizeMake(500,325)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (void)addRewardIsFinished:(SNFAddReward *)addReward{
	[self reloadRewards];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row == 0){
		return NO;
	}
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	if(indexPath.row == 0){
		return;
	}
	SNFReward *reward = [_sortedRewards objectAtIndex:indexPath.row - 1];
	self.rewardInfoLabel.text = [NSString stringWithFormat:@"%.2f Smiles = %.2f %@", reward.smile_amount.floatValue, reward.currency_amount.floatValue, reward.title];
}



@end
