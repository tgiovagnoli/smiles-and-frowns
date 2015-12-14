
#import "SNFRewardCell.h"

@implementation SNFRewardCell

- (void) prepareForReuse {
	self.selected = FALSE;
}

- (void) setReward:(SNFReward *) reward {
	_reward = reward;
	
	if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeMoney]) {
		self.titleLabel.text = @"Money";
		self.imageView.image = [UIImage imageNamed:@"money"];
	}
	
	else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeTime]) {
		self.titleLabel.text = @"Time";
		self.imageView.image = [UIImage imageNamed:@"time"];
	}
	
	else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeTreat]) {
		self.titleLabel.text = @"Treat";
		self.imageView.image = [UIImage imageNamed:@"treat"];
	}
	
	else if([reward.currency_type isEqualToString:SNFRewardCurrencyTypeGoal]) {
		self.titleLabel.text = @"Goal";
		self.imageView.image = [UIImage imageNamed:@"goal"];
	}
	
	else {
		self.titleLabel.text = @"Goal";
		self.imageView.image = [UIImage imageNamed:@"goal"];
	}
}

- (void) setSelected:(BOOL)selected {
	[super setSelected:selected];
	if(selected) {
		self.backgroundColor = [UIColor whiteColor];
	} else {
		self.backgroundColor = [UIColor clearColor];
	}
	
}

@end
