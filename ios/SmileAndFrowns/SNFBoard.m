#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBoard

+ (NSDictionary *)keyMappings{
	return @{
		@"title": @"title",
		@"deleted": @"deleted",
		@"uuid": @"uuid",
		@"transaction_id": @"transaction_id",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"owner": @"owner"
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	self.uuid = [[NSUUID UUID] UUIDString];
	if(!self.title){
		self.title = @"Untitled";
	}
	[super awakeFromInsert];
}

@end
