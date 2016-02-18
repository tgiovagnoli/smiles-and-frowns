
#import "SNFAddReward.h"
#import "SNFModel.h"
#import "SNFFormStyles.h"
#import "SNFSyncService.h"

@interface SNFAddReward ()
@property CGFloat smilesStepperValue;
@end

@implementation SNFAddReward

- (void)viewDidLoad{
	[super viewDidLoad];
	self.smilesStepperValue = 1;
	[self updateUI];
	[self startBannerAd];
	[SNFFormStyles roundEdgesOnButton:self.addReward];
	[SNFFormStyles updateFontOnSegmentControl:self.typeControl];
	[self startInterstitialAd];
}

- (void) updateUI {
	
	if(self.smilesStepperValue < 1) {
		self.smilesStepperValue = 1;
	}
	
	if(self.smilesStepperValue > 100) {
		self.smilesStepperValue = 100;
	}
	
	if(self.smilesStepperValue == 1) {
		self.subtractButton.enabled = FALSE;
	}
	
	if(self.smilesStepperValue > 1) {
		self.addButton.enabled  = TRUE;
		self.subtractButton.enabled = TRUE;
	}
	
	if(self.smilesStepperValue == 100) {
		self.addButton.enabled = FALSE;
	}
	
	self.smilesAmountLabel.text = [NSString stringWithFormat:@"%.0f", self.smilesStepperValue];
	//self.currencyAmountLabel.text = [NSString stringWithFormat:@"%.02f", self.currencyStepper.value];
	
	[self onTypeUpdate:nil];
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
	if(self.typeControl.selectedSegmentIndex == SNFAddRewardCurrencyMoney) {
		self.baseRateLabel.text = @"Write money as a percentage, like “.25 Dollars” for a quarter";
	} else {
		self.baseRateLabel.text = @"Write rewards simply, like \"hour of TV\" or \"trip to the zoo\"";
	}
}

- (IBAction) onAddReward:(UIButton *) sender {
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
	double currency = 0;
	if(self.baseRateField.text.length < 1) {
		currency = 1;
	} else {
		currency = [self.baseRateField.text doubleValue];
	}
	self.reward.currency_amount = [NSNumber numberWithDouble:currency];
	self.reward.smile_amount = [NSNumber numberWithInteger:self.smilesStepperValue];
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

- (IBAction) add:(id)sender {
	self.smilesStepperValue += 1;
	[self updateUI];
}

- (IBAction) subtract:(id)sender {
	self.smilesStepperValue -= 1;
	
	[self updateUI];
}

@end
