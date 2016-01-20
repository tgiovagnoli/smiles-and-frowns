#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBehavior

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"predefined_behavior_uuid":@"predefined_behavior_uuid",
		@"title": @"title",
		@"note": @"note",
		@"soft_deleted": @"deleted",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"remote_id": @"id",
		@"board": @"board",
		@"positive": @"positive",
		@"group":@"group",
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	if(!self.uuid) {
		self.uuid = [[NSUUID UUID] UUIDString];
	}
	if(!self.predefined_behavior_uuid) {
		self.predefined_behavior_uuid = @"";
	}
	if(!self.note){
		self.note = @"";
	}
	if(!self.title){
		self.title = @"Untitled";
	}
	if(!self.group) {
		self.group = @"";
	}
	self.soft_deleted = @NO;
	[super awakeFromInsert];
}

@end
