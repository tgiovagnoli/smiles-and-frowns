
#import "SNFBoardEdit.h"
#import "SNFModel.h"
#import "UIAlertAction+Additions.h"
#import "UIViewController+ModalCreation.h"
#import "SNFSyncService.h"
#import "SNFBoardDetailHeader.h"
#import "Utils.h"

NSString * const SNFBoardEditFinished = @"SNFBoardEditFinished";

@interface SNFBoardEdit ()
@property NSInteger selectedIndexPathRow;
@end

@implementation SNFBoardEdit

- (void) viewDidLoad {
	[super viewDidLoad];
	self.rewardInfoLabel.text = @" ";
	[self.rewardsCollectionView registerClass:[SNFRewardCell class] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollectionView registerNib:[UINib nibWithNibName:@"SNFRewardCell" bundle:nil] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollectionView registerClass:[SNFAddCell class] forCellWithReuseIdentifier:@"SNFAddCell"];
	[self.rewardsCollectionView registerNib:[UINib nibWithNibName:@"SNFAddCell" bundle:nil] forCellWithReuseIdentifier:@"SNFAddCell"];
	[self startBannerAd];
	[self decorate];
	[self startInterstitialAd];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.addBehaviorButton];
	[SNFFormStyles roundEdgesOnButton:self.useBoardButton];
	[SNFFormStyles roundEdgesOnButton:self.cancelButton];
	
	self.noBehaviorsMessage.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.noBehaviorsMessage.layer.shadowOffset = CGSizeMake(0,1);
	self.noBehaviorsMessage.layer.shadowOpacity = .2;
	self.noBehaviorsMessage.layer.shadowRadius = 1;
}

- (void) setBoard:(SNFBoard *) board {
	_board = board;
	[[SNFSyncService instance] saveContext];
	[self updateUI];
}

- (void) updateUI {
	self.boardTitleField.text = self.board.title;
	
	NSString * permission = [self.board permissionForUser: [SNFModel sharedInstance].loggedInUser ];
	if(![permission isEqualToString:@"owner"]) {
		self.boardTitleField.enabled = FALSE;
		self.boardTitleField.borderStyle = UITextBorderStyleNone;
		self.boardTitleField.backgroundColor = [UIColor clearColor];
		//self.boardTitleField.textAlignment = NSTextAlignmentCenter;
	}
	
	[self reloadBehaviors];
	[self reloadRewards];
}

- (void) reloadBehaviors {
	_positiveBehaviors = [self.board sortedActivePositiveBehaviors];
	_negativeBehaviors = [self.board sortedActiveNegativeBehaviors];
	[self.behaviorsTable reloadData];
	
	if(_positiveBehaviors.count < 1 && _negativeBehaviors.count < 1){
		[self showNoBehaviorsMessage];
	} else {
		[self.noBehaviorsMessage removeFromSuperview];
	}
}

- (void) showNoBehaviorsMessage {
	[self.formView addSubview:self.noBehaviorsMessage];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if(textField == self.boardTitleField) {
		
		if([textField.text isEmpty]) {
			return NO;
		}
		
		[textField resignFirstResponder];
		
		_board.title = self.boardTitleField.text;
		[[SNFSyncService instance] saveContext];
		
		return YES;
		
	}
	
	return YES;
}

// behaviors
- (IBAction)onAddBehavior:(UIButton *)sender{
	[self.noBehaviorsMessage removeFromSuperview];
	SNFAddBehavior * addBehavior = [[SNFAddBehavior alloc] initWithSourceView:self.addBehaviorButton sourceRect:CGRectZero contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
	[self presentViewController:addBehavior animated:YES completion:^{}];
	addBehavior.board = self.board;
	addBehavior.delegate = self;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch((SNFBoardEditBehaviorType)section) {
		case SNFBoardEditBehaviorTypePositive:
			return _positiveBehaviors.count;
			break;
		case SNFBoardEditBehaviorTypeNegative:
			return _negativeBehaviors.count;
			break;
	}
	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	SNFBoardDetailHeader * view = [[SNFBoardDetailHeader alloc] init];
	
	switch((SNFBoardEditBehaviorType)section) {
		case SNFBoardEditBehaviorTypePositive:
			view.textLabel.text = @"Smiles";
			break;
		case SNFBoardEditBehaviorTypeNegative:
			view.textLabel.text = @"Frowns";
			break;
	}
	return view;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	if(tableView == self.behaviorsTable){
		SNFBehavior *behavior;
		switch((SNFBoardEditBehaviorType)indexPath.section) {
			case SNFBoardEditBehaviorTypePositive:
				behavior = [_positiveBehaviors objectAtIndex:indexPath.row];
				break;
			case SNFBoardEditBehaviorTypeNegative:
				behavior = [_negativeBehaviors objectAtIndex:indexPath.row];
				break;
		}
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
	//[[SNFModel sharedInstance].managedObjectContext undo];
	
	if(self.delegate){
		[self.delegate boardEditor:self finishedWithBoard:self.board];
	}
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onCancel:(UIButton *)sender{
	
	if([self.boardTitleField.text isEmpty]) {
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must set a title for this board" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:YES completion:^{}];
		return;
	}
	
	_board.title = self.boardTitleField.text;
	
	[[SNFSyncService instance] saveContext];
	//[[SNFModel sharedInstance].managedObjectContext undo];
	
	if(self.delegate) {
		[self.delegate boardEditor:self finishedWithBoard:self.board];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFBoardEditFinished object:nil];
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return _sortedRewards.count;
}

- (NSString *) rewardLabel:(SNFReward *) reward {
	CGFloat smileAmount = reward.smile_amount.floatValue;
	CGFloat currentyAmount = reward.currency_amount.floatValue;
	NSMutableString * label = [[NSMutableString alloc] init];
	NSString * smile = @"Smiles";
	if(smileAmount == 1) {
		smile = @"Smile";
	}
	if([Utils CGFloatHasDecimals:smileAmount]) {
		[label appendFormat:@"%.2f",smileAmount];
	} else {
		[label appendFormat:@"%.0f",smileAmount];
	}
	[label appendFormat:@" %@",smile];
	[label appendFormat:@" = "];
	if([Utils CGFloatHasDecimals:currentyAmount]) {
		[label appendFormat:@"%.2f",currentyAmount];
	} else {
		[label appendFormat:@"%.0f",currentyAmount];
	}
	[label appendFormat:@" %@",reward.title];
	return label;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	SNFRewardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SNFRewardCell" forIndexPath:indexPath];
	SNFReward * reward = [_sortedRewards objectAtIndex:indexPath.row];
	
	cell.selected = false;
	
	if(indexPath.row == 0 && self.selectedIndexPathRow == -1) {
		cell.selected = TRUE;
	}
	
	if(indexPath.row == self.selectedIndexPathRow) {
		cell.selected = TRUE;
	}
	
	self.rewardInfoLabel.text = [self rewardLabel:reward];
	cell.reward = reward;
	
	return cell;
}

- (void)addCellWantsToAdd:(SNFAddCell *)addCell{
	SNFAddReward *addReward = [[SNFAddReward alloc] initWithSourceView:addCell sourceRect:CGRectZero contentSize:CGSizeMake(500,350)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (IBAction) addReward:(id)sender {
	SNFAddReward *addReward = [[SNFAddReward alloc] initWithSourceView:self.addRewardButton sourceRect:CGRectZero contentSize:CGSizeMake(500,350)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (void)addRewardIsFinished:(SNFAddReward *)addReward{
	[self reloadRewards];
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
	
	self.selectedIndexPathRow = indexPath.row;
	
	for (int i = 0; i < _sortedRewards.count; i++) {
		NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
		UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:path];
		cell.selected = FALSE;
	}
	
	SNFReward *reward = [_sortedRewards objectAtIndex:indexPath.row];
	self.rewardInfoLabel.text = [self rewardLabel:reward];
}

@end
