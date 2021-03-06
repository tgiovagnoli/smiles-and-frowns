#import "SNFSmile.h"

@implementation SNFSmile

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"soft_deleted": @"deleted",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"created_date": @"created_date",
		@"device_date": @"device_date",
		@"board": @"board",
		@"behavior": @"behavior",
		@"collected": @"collected",
		@"note": @"note",
		@"user": @"user",
		@"creator": @"creator",
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	if(!self.uuid) {
		self.uuid = [[NSUUID UUID] UUIDString];
	}
	if(!self.note){
		self.note = @"";
	}
	[super awakeFromInsert];
}

@end
