
#import "SNFAddReward.h"
#import "SNFModel.h"
#import "SNFFormStyles.h"
#import "SNFSyncService.h"

@implementation SNFAddReward

- (void)viewDidLoad{
	[super viewDidLoad];
	[self updateUI];
	[self startBannerAd];
	[SNFFormStyles roundEdgesOnButton:self.addReward];
	[SNFFormStyles updateFontOnSegmentControl:self.typeControl];
	[self startInterstitialAd];
}

- (void) updateUI {
	self.smilesAmountLabel.text = [NSString stringWithFormat:@"%.0f", self.smilesStepper.value];
	//self.currencyAmountLabel.text = [NSString stringWithFormat:@"%.02f", self.currencyStepper.value];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)onSmileAmountUpdate:(UIStepper *)sender{
	self.smilesAmountLabel.text = [NSString stringWithFormat:@"%.0f", sender.value];
}

- (IBAction)onCurrencyAmountUpdate:(UIStepper *)sender{
	//self.currencyAmountLabel.text = [NSString stringWithFormat:@"%.02f", sender.value];
}

- (IBAction)onTypeUpdate:(UISegmentedControl *)sender{
	if(self.typeControl.selectedSegmentIndex == 1) {
		self.baseRateLabel.text = @"Write money as a percentage, like “.25 Dollars” for a quarter";
	} else {
		self.baseRateLabel.text = @"Write rewards simply, like \"an hour of TV\" or \"a trip to the zoo\"";
	}
}

- (IBAction) onAddReward:(UIButton *) sender {
	
	if(self.baseRateField.text.length < 1) {
		[self displayOKAlertWithTitle:@"Error" message:@"Base rate cannot be empty" completion:nil];
		return;
	}
	
	NSError * error = nil;
	NSRegularExpression * expresstion = [[NSRegularExpression alloc] initWithPattern:@"^\\d*[\\.|\\,]?\\d*$" options:0 error:&error];
	if(error) {
		NSLog(@"error: %@",error);
	}
	
	NSArray <NSTextCheckingResult *> * matches = [expresstion matchesInString:self.baseRateField.text options:0 range:NSMakeRange(0, self.baseRateField.text.length)];
	if(matches.count < 1) {
		NSLog(@"no matches");
		[self displayOKAlertWithTitle:@"Error" message:@"Base rate can only contain decimals or whole numbers." completion:nil];
		return;
	}
	
	if(self.titleField.text.length < 1 && self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyMoney) {
		[self displayOKAlertWithTitle:@"Error" message:@"When creating a monetary reward, you need to write your value as a percentage. For instance, \".25 Dollars\" is the way to write a quarter." completion:nil];
		return;
	}
	
	if(!self.reward) {
		NSDictionary * rewardData = @{
			@"uuid": [[NSUUID UUID] UUIDString],
			@"board": @{@"uuid": self.board.uuid},
		};
		_reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardData withContext:[SNFModel sharedInstance].managedObjectContext];
	}
	
	
	[self updateReward];
	
	[[SNFSyncService instance] saveContext];
	
	NSLog(@"%@", self.reward);
	if(self.delegate) {
		[self.delegate addRewardIsFinished:self];
	}
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) updateReward {
	self.reward.currency_amount = [NSNumber numberWithDouble:[self.baseRateField.text doubleValue]];
	self.reward.smile_amount = [NSNumber numberWithInteger:self.smilesStepper.value];
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
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
