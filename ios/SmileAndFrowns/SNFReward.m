#import "SNFReward.h"
#import "SNFBoard.h"

@implementation SNFReward

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"soft_deleted": @"deleted",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"board": @"board",
		@"title": @"title",
		@"currency_amount": @"currency_amount",
		@"smile_amount": @"smile_amount",
		@"currency_type": @"currency_type",
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	if(!self.uuid) {
		self.uuid = [[NSUUID UUID] UUIDString];
	}
	if(!self.title){
		self.title = @"Untitled";
	}
	if(!self.currency_amount){
		self.currency_amount = @1.0;
	}
	if(!self.smile_amount){
		self.smile_amount = @1.0;
	}
	if(!self.currency_type){
		self.currency_type = SNFRewardCurrencyTypeMoney;
	}
	[super awakeFromInsert];
}


@end
