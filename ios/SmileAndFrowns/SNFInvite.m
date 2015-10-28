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

// TODO: invite needs created and updated
- (void) awakeFromInsert{
	self.uuid = [[NSUUID UUID] UUIDString];
	[super awakeFromInsert];
}

@end
