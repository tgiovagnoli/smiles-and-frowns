#import "SNFSpendRewards.h"
#import "SNFModel.h"
#import "UIViewController+ModalCreation.h"
#import "SNFSyncService.h"
#import "UIImageView+LocalCache.h"

@implementation SNFSpendRewards

- (void)viewDidLoad{
	[super viewDidLoad];
	self.rewardsInfoLabel.text = @"";
	[self.rewardsCollection registerClass:[SNFRewardCell class] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollection registerNib:[UINib nibWithNibName:@"SNFRewardCell" bundle:nil] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollection registerClass:[SNFAddCell class] forCellWithReuseIdentifier:@"SNFAddCell"];
	[self.rewardsCollection registerNib:[UINib nibWithNibName:@"SNFAddCell" bundle:nil] forCellWithReuseIdentifier:@"SNFAddCell"];
	
	self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.width/2;
	self.userProfileImageView.layer.borderWidth = 2;
	self.userProfileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
	self.userProfileImageView.layer.masksToBounds = TRUE;
	
	[self startBannerAd];
	[self updateUI];
}

- (void)updateUI{
	[self reloadRewards];
	[self updateUserInfo];
}

- (void)updateUserInfo{
	self.userFirstLastLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.first_name, self.user.last_name];
	self.userGenderAgeLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.gender, self.user.age];
	
	// calculate the number of smiles available from the board
	_smilesAvailable = 0;
	
	for(SNFSmile *smile in [self.board smilesForUser:self.user]){
		if(!smile.collected.boolValue && !smile.soft_deleted.boolValue){
			_smilesAvailable ++;
		}
	}
	
	for(SNFFrown *frown in [self.board frownsForUser:self.user]){
		if(!frown.soft_deleted.boolValue){
			_smilesAvailable --;
		}
	}
	
	self.totalSmilestoSpendLabel.text = [NSString stringWithFormat:@"%ld", (long)_smilesAvailable];
	
	[self setImageByGender];
	
	if(self.user.image) {
		NSURL * url = [NSURL URLWithString:self.user.image];
		[self.userProfileImageView setImageForURL:url withCompletion:^(NSError *error, UIImage *image) {
			if(error) {
				[self setImageByGender];
			}
		}];
	}
}

- (void) setImageByGender {
	if([self.user.gender.lowercaseString isEqualToString:@"male"]) {
		self.userProfileImageView.image = [UIImage imageNamed:@"male"];
	} else {
		self.userProfileImageView.image = [UIImage imageNamed:@"female"];
	}
}

- (void)reloadRewards{
	_sortedRewards = [self.board sortedActiveRewards];
	[self.rewardsCollection reloadData];
	if([self.rewardsCollection indexPathsForSelectedItems].count == 0 && _sortedRewards.count > 0){
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
		[self.rewardsCollection selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
		[self collectionView:self.rewardsCollection didSelectItemAtIndexPath:indexPath];
	}
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI];
}

- (void)setUser:(SNFUser *)user{
	_user = user;
	[self updateUI];
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
	_selectedReward = [_sortedRewards objectAtIndex:indexPath.row - 1];
	self.rewardsInfoLabel.text = [NSString stringWithFormat:@"%.2f Smiles = %.2f %@", _selectedReward.smile_amount.floatValue, _selectedReward.currency_amount.floatValue, _selectedReward.title];
	[self updateStepperForReward];
}

- (void)addCellWantsToAdd:(SNFAddCell *)addCell{
	SNFAddReward * addReward = [[SNFAddReward alloc] initWithSourceView:addCell sourceRect:CGRectZero contentSize:CGSizeMake(500,325)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (void)addRewardIsFinished:(SNFAddReward *)addReward{
	[self.rewardsCollection reloadData];
}

- (void)updateStepperForReward{
	if(_smilesAvailable <= 0 || _smilesAvailable < _selectedReward.smile_amount.floatValue){
		self.incrementStepper.maximumValue = 1.0;
		self.incrementStepper.minimumValue = 1.0;
		self.incrementStepper.value = 1.0;
	}
	self.incrementStepper.maximumValue = floor(_smilesAvailable/_selectedReward.smile_amount.floatValue);
	self.incrementStepper.minimumValue = 1.0;
	if(self.incrementStepper.value > self.incrementStepper.maximumValue){
		self.incrementStepper.value = self.incrementStepper.maximumValue;
	}
	[self updateSmileAndRewardsLabels];
}

- (IBAction)onRewardModifierChange:(UIStepper *)sender{
	[self updateSmileAndRewardsLabels];
}

- (IBAction)onMax:(UIButton *)sender{
	self.incrementStepper.value = self.incrementStepper.maximumValue;
	[self updateSmileAndRewardsLabels];
}

- (void)updateSmileAndRewardsLabels{
	self.spendSmilesLabel.text = [NSString stringWithFormat:@"%.0f", self.incrementStepper.value * _selectedReward.smile_amount.floatValue];
	self.rewardCalculatedLabel.text = [NSString stringWithFormat:@"= %.0f %@", self.incrementStepper.value * _selectedReward.currency_amount.floatValue, _selectedReward.title];
}

- (IBAction)onCancel:(UIButton *)sender{
	if(self.delegate){
		[self.delegate spendRewardsIsDone:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onRedeemReward:(UIButton *)sender{
	CGFloat currency = _selectedReward.currency_amount.floatValue * self.incrementStepper.value;
	CGFloat smiles = _selectedReward.smile_amount.floatValue * self.incrementStepper.value;
	if(smiles > _smilesAvailable){
		NSString *alertMessage = [NSString stringWithFormat:@"%@ does not have enough smiles to purchase %.2f %@",self.user.first_name, currency, _selectedReward.title];
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:YES completion:^{}];
	}else{
		NSString *alertMessage = [NSString stringWithFormat:@"Are you sure you want to spend %.0f smiles?", smiles];
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self redeemReward];
		}]];
		[self presentViewController:alert animated:YES completion:^{}];
	}
}

- (void)redeemReward{
	CGFloat smiles = _selectedReward.smile_amount.floatValue * self.incrementStepper.value;
	NSInteger smilesTaken = 0;
	for(SNFSmile *smile in [self.board smilesForUser:self.user]){
		if(smilesTaken < smiles){
			smile.collected = @YES;
		}
		smilesTaken ++;
	}
	[[SNFSyncService instance] saveContext];
	if(self.delegate){
		[self.delegate spendRewardsIsDone:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
