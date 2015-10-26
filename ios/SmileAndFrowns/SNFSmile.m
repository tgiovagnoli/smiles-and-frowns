#import "SNFSmile.h"

@implementation SNFSmile

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
