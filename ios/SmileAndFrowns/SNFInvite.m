#import "SNFInvite.h"
#import "SNFBoard.h"

@implementation SNFInvite

+ (NSDictionary *)keyMappings{
	return @{
		@"role": @"role",
		@"code": @"code",
		@"remote_id": @"id",
		@"board": @"board",
		@"uuid": @"uuid"
	};
}


@end
