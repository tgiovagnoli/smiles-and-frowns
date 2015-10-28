#import "SNFReward.h"
#import "SNFBoard.h"

@implementation SNFReward

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"deleted": @"deleted",
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
	self.uuid = [[NSUUID UUID] UUIDString];
	[super awakeFromInsert];
}


@end
