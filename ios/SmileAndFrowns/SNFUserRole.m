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
		@"updated_date": @"updated_date",
		@"created_date": @"created_date",
		@"role": @"role",
		@"soft_deleted": @"deleted",
	};
}


- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	if(!self.uuid) {
		self.uuid = [[NSUUID UUID] UUIDString];
	}
	if(!self.role){
		self.role = SNFUserRoleChild;
	}
	[super awakeFromInsert];
}


@end
