#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFBoard.h"

@implementation SNFFrown

+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"deleted": @"deleted",
				@"remote_id": @"id",
				@"updated_date": @"updated_date",
				@"created_date": @"created_date",
				@"board": @"board",
				@"behavior": @"behavior",
				@"user": @"user"
			 };
}


@end
