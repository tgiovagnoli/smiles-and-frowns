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
		@"collected": @"collected",
		@"user": @"user"
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
