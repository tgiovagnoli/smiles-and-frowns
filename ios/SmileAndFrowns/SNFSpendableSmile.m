
#import "SNFSpendableSmile.h"
#import "SNFBoard.h"
#import "SNFUser.h"

@implementation SNFSpendableSmile

+ (NSDictionary *)keyMappings{
	return @{
			 @"uuid": @"uuid",
			 @"soft_deleted": @"deleted",
			 @"remote_id": @"id",
			 @"updated_date": @"updated_date",
			 @"created_date": @"created_date",
			 @"board": @"board",
			 @"collected": @"collected",
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
	[super awakeFromInsert];
}

@end
