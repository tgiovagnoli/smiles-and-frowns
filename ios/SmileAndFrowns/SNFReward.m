#import "SNFReward.h"
#import "SNFBoard.h"

@implementation SNFReward

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"deleted": @"deleted",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"created_date": @"created_date",
		@"board": @"board",
		@"title": @"title",
		@"currency_amount": @"currency_amount",
		@"smile_amount": @"smile_amount",
		@"currency_type": @"currency_type",
	};
}

@end
