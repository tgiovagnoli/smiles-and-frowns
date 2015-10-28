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
		@"device_date": @"device_date",
		@"updated_date": @"updated_date"
	};
}


- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	self.uuid = [[NSUUID UUID] UUIDString];
	[super awakeFromInsert];
}


@end
