#import "SNFUserRole.h"
#import "SNFBoard.h"
#import "SNFUser.h"

#define SNFUserRoleChild @"child"
#define SNFUserRoleParent @"parent"
#define SNFUserRoleGuardian @"guardian"

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
	if(!self.role){
		self.role = SNFUserRoleChild;
	}
	[super awakeFromInsert];
}


@end
