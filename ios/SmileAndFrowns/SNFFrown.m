#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFBoard.h"

@implementation SNFFrown

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"soft_deleted": @"deleted",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"created_date": @"created_date",
		@"board": @"board",
		@"behavior": @"behavior",
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
