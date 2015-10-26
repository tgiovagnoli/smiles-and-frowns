#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBoard

+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"title": @"title",
				@"deleted": @"deleted",
				@"transaction_id": @"transaction_id",
				@"remote_id": @"id",
				@"updated_date": @"updated_date",
				@"created_date": @"created_date",
				@"edit_count": @"edit_count",
			 };
}




@end
