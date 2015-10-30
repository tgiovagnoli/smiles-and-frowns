
#import "SNFInvite.h"
#import "SNFBoard.h"

@implementation SNFInvite

+ (NSDictionary *) keyMappings {
	return @{
		@"uuid": @"uuid",
		@"code": @"code",
		@"remote_id": @"id",
		@"board_uuid": @"board",
		@"board_title": @"board_title",
		@"sender_last_name": @"sender_last_name",
		@"sender_first_name": @"sender_first_name",
		@"created_date": @"created_date",
		@"accepted": @"accepted",
	};
}

@end
