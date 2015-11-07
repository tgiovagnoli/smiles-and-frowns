#import "SNFAddReward.h"
#import "SNFModel.h"

@implementation SNFAddReward

- (void)viewDidLoad{
	[super viewDidLoad];
	[self updateUI];
	[self startBannerAd];
}

- (void)updateUI{
	self.smilesAmountLabel.text = [NSString stringWithFormat:@"%f", self.smilesStepper.value];
	self.currencyAmountLabel.text = [NSString stringWithFormat:@"%f", self.currencyStepper.value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)onSmileAmountUpdate:(UIStepper *)sender{
	self.smilesAmountLabel.text = [NSString stringWithFormat:@"%f", sender.value];
}


- (IBAction)onCurrencyAmountUpdate:(UIStepper *)sender{
	self.currencyAmountLabel.text = [NSString stringWithFormat:@"%f", sender.value];
}

- (IBAction)onTypeUpdate:(UISegmentedControl *)sender{
	
}

- (IBAction)onAddReward:(UIButton *)sender{
	if(!self.reward){
		NSDictionary *rewardData = @{
									 @"uuid": [[NSUUID UUID] UUIDString],
									 @"board": @{@"uuid": self.board.uuid},
									 };
		_reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardData withContext:[SNFModel sharedInstance].managedObjectContext];
	}
	[self updateReward];
	NSLog(@"%@", self.reward);
	if(self.delegate){
		[self.delegate addRewardIsFinished:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateReward{
	self.reward.currency_amount = [NSNumber numberWithFloat:self.currencyStepper.value];
	self.reward.smile_amount = [NSNumber numberWithFloat:self.smilesStepper.value];
	self.reward.title = self.titleField.text;
	// time, money, treat, goal
	if(self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyTime){
		self.reward.currency_type = SNFRewardCurrencyTypeTime;
	}else if(self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyMoney){
		self.reward.currency_type = SNFRewardCurrencyTypeMoney;
	}else if(self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyTreat){
		self.reward.currency_type = SNFRewardCurrencyTypeTreat;
	}else if(self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyGoal){
		self.reward.currency_type = SNFRewardCurrencyTypeGoal;
	}
	NSLog(@"adding reward with currency type %@", self.reward.currency_type);
}

- (IBAction)onCancel:(UIButton *)sender{
	if(self.delegate){
		[self.delegate addRewardIsFinished:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
