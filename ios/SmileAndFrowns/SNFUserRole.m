#import "SNFUserRole.h"
#import "SNFBoard.h"
#import "SNFUser.h"

@implementation SNFUserRole

+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"remote_id": @"id",
				@"board": @"board",
				@"user": @"user",
			 };
}

@end
