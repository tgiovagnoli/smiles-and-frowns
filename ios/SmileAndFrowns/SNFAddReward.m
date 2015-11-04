#import "SNFAddReward.h"

@implementation SNFAddReward

- (void)viewDidLoad{
	[super viewDidLoad];
	[self updateUI];
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

@end
