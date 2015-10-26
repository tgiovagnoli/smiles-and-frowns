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
			 };
}

@end
