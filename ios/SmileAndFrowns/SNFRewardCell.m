#import "SNFRewardCell.h"

@implementation SNFRewardCell


- (void)setReward:(SNFReward *)reward{
	_reward = reward;
	if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeMoney]){
		self.titleLabel.text = @"$";
	}else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeGoal]){
		self.titleLabel.text = @"goal";
	}else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeTreat]){
		self.titleLabel.text = @"treat";
	}else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeGoal]){
		self.titleLabel.text = @"goal";
	}else{
		self.titleLabel.text = @"goal";
	}
}

@end
