#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBehavior

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"title": @"title",
		@"note": @"note",
		@"deleted": @"deleted",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"remote_id": @"id",
		@"board": @"board",
		@"positive": @"positive",
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	self.uuid = [[NSUUID UUID] UUIDString];
	self.deleted = @NO;
	if(!self.note){
		self.note = @"";
	}
	if(!self.title){
		self.title = @"Untitled";
	}
	[super awakeFromInsert];
}

@end
