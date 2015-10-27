#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBehavior

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"title": @"title",
		@"note": @"note",
		@"deleted": @"deleted",
		@"created_date": @"created_date",
		@"updated_date": @"updated_date",
		@"remote_id": @"id",
		@"board": @"board",
	};
}


@end
