
#import "SNFSpendRewards.h"
#import "SNFModel.h"
#import "UIViewController+ModalCreation.h"
#import "SNFSyncService.h"
#import "UIImageView+DiskCache.h"
#import "NSString+Additions.h"
#import "UIViewController+Alerts.h"
#import "Utils.h"
#import "SNFFormStyles.h"
#import "NSTimer+Blocks.h"
#import "NSLog+Geom.h"

@interface SNFSpendRewards ()
@property float spendAmount;
@property NSInteger selectedIndexPathRow;
@property UIPanGestureRecognizer * swipeGesture;
@property CGFloat swipex;
@property CGFloat rewardsConstant;
@property bool firstlayoutself;
@end

@implementation SNFSpendRewards

- (void) viewDidLoad {
	[super viewDidLoad];
	
	self.firstlayoutself = true;
	self.spendAmount = 0;
	self.selectedIndexPathRow = -1;
	
	self.rewardsInfoLabel.text = @"";
	[self.rewardsCollection registerClass:[SNFRewardCell class] forCellWithReuseIdentifier:@"SNFRewardCell"];
	[self.rewardsCollection registerNib:[UINib nibWithNibName:@"SNFRewardCell" bundle:nil] forCellWithReuseIdentifier:@"SNFRewardCell"];
	
	self.userProfileImageView.layer.cornerRadius = self.userProfileImageView.width/2;
	self.userProfileImageView.layer.borderWidth = 2;
	self.userProfileImageView.layer.borderColor = [[UIColor whiteColor] CGColor];
	self.userProfileImageView.layer.masksToBounds = TRUE;
	
	[SNFFormStyles roundEdgesOnButton:self.spendSmileButton];
	
	self.spendAmountView.backgroundColor = [UIColor clearColor];
	self.spendAmountView.layer.borderColor = [[UIColor colorWithRed:0.959 green:0.933 blue:0.902 alpha:1] CGColor];
	self.spendAmountView.layer.borderWidth = 2;
	
	self.swipeGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onSwipeGestureChange:)];
	self.swipeGesture.minimumNumberOfTouches = 1;
	self.swipeGesture.maximumNumberOfTouches = 1;
	[self.rewardsViewContainer addGestureRecognizer:self.swipeGesture];
	
	self.deleteButton.alpha = 0;
	
	[self startBannerAd];
	[self updateUI];
	[self updateRewardsInfoLabel];
}

- (void) viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	NSLog(@"view did layout subviews");
	if(self.firstlayoutself) {
		[NSTimer scheduledTimerWithTimeInterval:.1 block:^{
			[self setupRewardsInfo];
		} repeats:FALSE];
		self.firstlayoutself = false;
	}
	[self updateRewardsInfoLabel];
}

- (void) setupRewardsInfo {
	
	self.deleteButton.alpha = 1;
	
	CGRect f = CGRectMake(0,0,self.rewardsViewContainer.frame.size.width,self.rewardsViewContainer.frame.size.height);
	self.rewardsView.frame = f;
	[self.rewardsViewContainer addSubview:self.rewardsView];
	//self.rewardsView.backgroundColor = [UIColor redColor];
	
	self.rewardsInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(45,0,self.rewardsViewContainer.width-90,54)];
	self.rewardsInfoLabel.textAlignment = NSTextAlignmentCenter;
	//self.rewardsInfoLabel.backgroundColor = [UIColor yellowColor];
	self.rewardsInfoLabel.adjustsFontSizeToFitWidth = TRUE;
	self.rewardsInfoLabel.minimumScaleFactor = .5;
	self.rewardsInfoLabel.text = @"reward info";
	self.rewardsInfoLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:17];
	self.rewardsInfoLabel.textColor = [SNFFormStyles darkGray];
	[self.rewardsView addSubview:self.rewardsInfoLabel];
	
	self.smileImage = [[UIImageView alloc] initWithFrame:CGRectMake(5,8,37,37)];
	self.smileImage.image = [UIImage imageNamed:@"smile"];
	[self.rewardsView addSubview:self.smileImage];
	
	[self updateRewardsInfoLabel];
}

- (void) onSwipeGestureChange:(UISwipeGestureRecognizer *) swipe {
	
	if(self.rewardsConstant == 0) {
		self.rewardsConstant = self.rewardsLeftConstraint.constant;
	}
	
	CGPoint loc = [swipe locationInView:self.rewardsViewContainer];
	
	if(swipe.state == UIGestureRecognizerStateBegan) {
		
		self.swipex = loc.x;
		
	} else if(swipe.state == UIGestureRecognizerStateChanged) {
		
		CGFloat diff = loc.x - self.swipex;
		
		if(self.rewardsView.x > -1 && diff > 0) {
			self.rewardsView.x = 0;
			return;
		}
		
		CGRect f = self.rewardsView.frame;
		f.origin.x += diff;
		self.rewardsView.frame = f;
		
		self.swipex = loc.x;
		
	} else if(swipe.state == UIGestureRecognizerStateEnded) {
		
		if(self.rewardsView.x < -75 || self.rewardsView.x < -35) {
			self.rewardsView.x = -75;
		} else if(self.rewardsView.x > -35) {
			self.rewardsView.x = 0;
		}
	}
}

- (IBAction) deleteReward:(id) sender {
	
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Reward?" message:@"Are you sure you want to delete this reward?" preferredStyle:UIAlertControllerStyleAlert];
	
	[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		_selectedReward.soft_deleted = @(1);
		[[SNFSyncService instance] saveContext];
		[self updateUI];
	}]];
	
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
	
	[self presentViewController:alert animated:YES completion:^{}];
}

- (void) updateUI {
	[self reloadRewards];
	[self updateUserInfo];
	[self updateSmileAndRewardsLabels];
}

- (void) updateUserInfo {
	self.userFirstLastLabel.text = [NSString stringWithFormat:@"%@ %@", self.user.first_name, self.user.last_name];
	
	if([self.user.gender isEqualToString:@"male"]) {
		self.userGenderAgeLabel.text = [NSString stringWithFormat:@"Male %@", self.user.age];
	} else {
		self.userGenderAgeLabel.text = [NSString stringWithFormat:@"Female %@", self.user.age];
	}
	
	// calculate the number of smiles available from the board
	//_smilesAvailable = 0;
	_smilesAvailable = [self.board smileCurrencyForUser:self.user];
	self.totalSmilestoSpendLabel.text = [NSString stringWithFormat:@"%ld", (long)_smilesAvailable];
	
	[self updateButtons];
	[self updateSmileAndRewardsLabels];
	[self setImageByGender];
	
	if(![self.user.image isEmpty] && self.user.image) {
		NSURL * url = [NSURL URLWithString:self.user.image];
		[self.userProfileImageView setImageWithDefaultAuthBasicForURL:url withCompletion:^(NSError *error, UIImage *image) {
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

- (void) reloadRewards {
	
	self.rewardsView.x = 0;
	_selectedIndexPathRow = 0;
	
	_sortedRewards = [self.board sortedActiveRewards];
	_selectedReward = [_sortedRewards objectAtIndex:0];
	[self.rewardsCollection reloadData];
	if([self.rewardsCollection indexPathsForSelectedItems].count == 0 && _sortedRewards.count > 0){
		NSIndexPath *indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
		[self.rewardsCollection selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionLeft];
		//[self collectionView:self.rewardsCollection didSelectItemAtIndexPath:indexPath];
	}
}

- (void) setBoard:(SNFBoard *) board {
	_board = board;
	[self updateUI];
}

- (void) setUser:(SNFUser *) user {
	_user = user;
	[self updateUI];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
	return _sortedRewards.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
	
	SNFRewardCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SNFRewardCell" forIndexPath:indexPath];
	
	cell.selected = FALSE;
	
	if(indexPath.row == 0 && self.selectedIndexPathRow == -1) {
		cell.selected = TRUE;
	}
	
	if(self.selectedIndexPathRow > -1) {
		if(indexPath.row == self.selectedIndexPathRow) {
			cell.selected = TRUE;
		}
	}
	
	SNFReward * reward = [_sortedRewards objectAtIndex:indexPath.row];
	cell.reward = reward;
	return cell;
}

- (BOOL) collectionView:(UICollectionView *) collectionView shouldSelectItemAtIndexPath:(NSIndexPath *) indexPath {
	return YES;
}

- (void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *) indexPath {
	_selectedReward = [_sortedRewards objectAtIndex:indexPath.row];
	
	self.spendAmount = 0;
	
	self.selectedIndexPathRow = indexPath.row;
	
	for (int i = 0; i < _sortedRewards.count; i++) {
		NSIndexPath * path = [NSIndexPath indexPathForRow:i inSection:0];
		UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:path];
		cell.selected = FALSE;
	}
	
	UICollectionViewCell * cell = [collectionView cellForItemAtIndexPath:indexPath];
	cell.selected = TRUE;
	
	[self updateRewardsInfoLabel];
	
	[self updateSmileAndRewardsLabels];
	
	[self updateButtons];
	
	if(self.rewardsInfoLabel.text) {
		
		[self updateRewardsInfoLabel];
		
	}
	
	self.rewardsView.x = 0;
}

- (void) updateRewardsInfoLabel {
	
	if(!self.rewardsInfoLabel) {
		return;
	}
	
	NSMutableString * label = [[NSMutableString alloc] init];
	
	if([Utils CGFloatHasDecimals:_selectedReward.smile_amount.floatValue]) {
		[label appendFormat:@"%.2f Smiles = ",_selectedReward.smile_amount.floatValue];
	} else {
		if(_selectedReward.smile_amount.integerValue == 1) {
			[label appendFormat:@"%.0f Smile = ",_selectedReward.smile_amount.floatValue];
		} else {
			[label appendFormat:@"%.0f Smiles = ",_selectedReward.smile_amount.floatValue];
		}
	}
	
	if([[_selectedReward currency_type] isEqualToString:SNFRewardCurrencyTypeMoney]) {
		[label appendString:@"$"];
	}
	
	if([Utils CGFloatHasDecimals:_selectedReward.currency_amount.floatValue]) {
		[label appendFormat:@"%.2f ",_selectedReward.currency_amount.floatValue];
	} else {
		if(_selectedReward.currency_amount.floatValue == 1) {
			[label appendFormat:@"%.0f ",_selectedReward.currency_amount.floatValue];
		} else {
			[label appendFormat:@"%.2f ",_selectedReward.currency_amount.floatValue];
		}
	}
	
	[label appendString:_selectedReward.title];
	
	self.rewardsInfoLabel.text = label;
	
	//update placement of smile image.
	NSDictionary * attributes = @{NSFontAttributeName:self.rewardsInfoLabel.font,};
	CGRect boundingRect = [self.rewardsInfoLabel.text boundingRectWithSize:self.rewardsInfoLabel.frame.size options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
	CGFloat left = (self.rewardsView.width/2) - (boundingRect.size.width/2) - (self.smileImage.width+6);
	
	NSLog(@"length: %lu",self.rewardsInfoLabel.text.length);
	
	if(self.rewardsInfoLabel.width > 320) {
		CGRect smileRect = CGRectMake(left, 8, self.smileImage.width, self.smileImage.height);
		self.smileImage.frame = smileRect;
	} else if(self.rewardsInfoLabel.text.length <= 24) {
		CGRect smileRect = CGRectMake(left, 8, self.smileImage.width, self.smileImage.height);
		self.smileImage.frame = smileRect;
	} else {
		self.smileImage.x = self.rewardsInfoLabel.x-(self.smileImage.width);
	}
}

- (void) addCellWantsToAdd:(SNFAddCell *) addCell {
	SNFAddReward * addReward = [[SNFAddReward alloc] initWithSourceView:addCell sourceRect:CGRectZero contentSize:CGSizeMake(500,325)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (IBAction) addReward:(id)sender {
	SNFAddReward * addReward = [[SNFAddReward alloc] initWithSourceView:self.addRewardButton sourceRect:CGRectZero contentSize:CGSizeMake(500,325)];
	addReward.board = self.board;
	addReward.delegate = self;
	[self presentViewController:addReward animated:YES completion:^{}];
}

- (void) addRewardIsFinished:(SNFAddReward *) addReward {
	[self reloadRewards];
	[self updateSmileAndRewardsLabels];
	[self updateRewardsInfoLabel];
}

- (CGFloat) maxSpendAmount {
	float max = _smilesAvailable;
	float rate = _selectedReward.smile_amount.floatValue;
	
	if(![Utils CGFloatHasDecimals:max/rate]) {
		return max;
	}
	
	while(max > 0 && [Utils CGFloatHasDecimals:max/rate]) {
		max--;
	}
	
	return max;
}

- (IBAction) onAdd:(id)sender {
	
	if(self.spendAmount < _smilesAvailable) {
		
		float tmp = self.spendAmount;
		float nxtMultiple = tmp;
		float added = tmp + _selectedReward.smile_amount.floatValue;
		BOOL shouldSubtract = FALSE;
		
		if(added > _smilesAvailable) {
			
			shouldSubtract = TRUE;
			
		}
		
		if([Utils CGFloatHasDecimals:added/_selectedReward.smile_amount.floatValue]) {
			while(nxtMultiple < _smilesAvailable && [Utils CGFloatHasDecimals:(float)nxtMultiple/_selectedReward.smile_amount.floatValue] ) {
				nxtMultiple ++;
			}
			self.spendAmount = nxtMultiple;
		} else {
			self.spendAmount += _selectedReward.smile_amount.floatValue;
		}
		
		if(shouldSubtract) {
			[self onSubtract:nil];
		}
	}
	
	if(self.spendAmount > _smilesAvailable) {
		self.spendAmount = _smilesAvailable;
	}
	
	if(_smilesAvailable < 1) {
		self.spendAmount = 0;
	}
	
	[self updateSmileAndRewardsLabels];
	[self updateButtons];
}

- (IBAction) onSubtract:(id) sender {
	
	if(self.spendAmount > 0) {
		
		float tmp = self.spendAmount;
		float nxtMultiple = tmp;
		float subtracted = tmp - _selectedReward.smile_amount.floatValue;
		
		if([Utils CGFloatHasDecimals:subtracted/_selectedReward.smile_amount.floatValue]) {
			while(nxtMultiple > 0 && [Utils CGFloatHasDecimals:(float)nxtMultiple/_selectedReward.smile_amount.floatValue] ) {
				nxtMultiple --;
			}
			self.spendAmount = nxtMultiple;
		} else {
			self.spendAmount -= _selectedReward.smile_amount.floatValue;
		}
	}
	
	if(_smilesAvailable == 0) {
		self.spendAmount = 0;
	}
	
	if(_smilesAvailable < 0) {
		self.spendAmount = 0;
	}
	
	[self updateSmileAndRewardsLabels];
	[self updateButtons];
}

- (void) updateButtons {
	self.subtractButton.alpha = 1;
	self.addButton.alpha = 1;
	
	float max = [self maxSpendAmount];
	
	if(self.spendAmount <= 0) {
		self.subtractButton.alpha = .5;
	}
	
	if(self.spendAmount >= max) {
		self.addButton.alpha = .5;
	}
	
	if(_smilesAvailable < 0) {
		self.maxButton.alpha = .5;
		self.maxButton.enabled = FALSE;
	} else {
		self.maxButton.alpha = 1;
		self.maxButton.enabled = TRUE;
	}
	
	if(self.spendAmount == 0) {
		
		if(_smilesAvailable < 1) {
			self.maxButton.alpha = .5;
			self.maxButton.enabled = false;
		}
		
		self.spendSmileButton.alpha = .75;
		self.spendSmileButton.enabled = false;
		
	} else {
		
		self.maxButton.alpha = 1;
		self.maxButton.enabled = true;
		
		self.spendSmileButton.alpha = 1;
		self.spendSmileButton.enabled = true;
	}
}

- (IBAction) onRewardModifierChange:(UIStepper *)sender{
	[self updateSmileAndRewardsLabels];
}

- (IBAction) onMax:(UIButton *)sender{
	self.spendAmount = [self maxSpendAmount];
	[self updateSmileAndRewardsLabels];
	[self updateButtons];
}

- (void) updateSmileAndRewardsLabels {
	self.spendSmilesLabel.text = [NSString stringWithFormat:@"%.0f", self.spendAmount];
	
	float amount = self.spendAmount;
	float rate = _selectedReward.smile_amount.floatValue;
	float currency = _selectedReward.currency_amount.floatValue;
	float total = (float) (amount/rate) * currency;
	
	NSMutableString * calc = [[NSMutableString alloc] initWithString:@""];
	
	[calc appendString:@"= "];
	
	if([_selectedReward.currency_type isEqualToString:SNFRewardCurrencyTypeMoney]) {
		[calc appendString:@"$"];
	}
	
	if([Utils CGFloatHasDecimals:total]) {
		[calc appendFormat:@"%.2f %@", total, _selectedReward.title];
	} else {
		[calc appendFormat:@"%.0f %@", total, _selectedReward.title];
	}
	
	self.rewardCalculatedLabel.text = calc;
	
}

- (IBAction)onCancel:(UIButton *)sender{
	//if(self.delegate){
	//	[self.delegate spendRewardsIsDone:self];
	//}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction) onRedeemReward:(UIButton *) sender {
	CGFloat smiles = self.spendAmount;
	
	if(smiles > _smilesAvailable) {
		
		NSString *alertMessage = [NSString stringWithFormat:@"%@ does not have enough smiles to purchase %.2f %@",self.user.first_name, smiles, _selectedReward.title];
		[self displayOKAlertWithTitle:@"Sorry" message:alertMessage completion:nil];
		
	} else {
		
		NSString * alertMessage = nil;
		if(smiles == 1) {
			alertMessage = [NSString stringWithFormat:@"Are you sure you want to spend %.0f smile?", smiles];
		} else {
			alertMessage = [NSString stringWithFormat:@"Are you sure you want to spend %.0f smiles?", smiles];
		}
		
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:alertMessage preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self redeemReward];
		}]];
		[self presentViewController:alert animated:YES completion:^{}];
	}
}

- (void) redeemReward {
	CGFloat smiles = self.spendAmount;
	
	NSInteger smilesTaken = 0;
	
	for(SNFSmile * smile in [self.board smilesForUser:self.user includeDeletedSmiles:FALSE includeCollectedSmiles:FALSE]) {
		if(smilesTaken < smiles) {
			smile.collected = @YES;
		}
		smilesTaken ++;
	}
	
	[[SNFSyncService instance] saveContext];
	
	if(self.delegate) {
		[self.delegate spendRewardsIsDone:self];
	}
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
