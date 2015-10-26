#import "SNFSmile.h"

@implementation SNFSmile

/*
 @dynamic modified_date;
 @dynamic created_date;
 @dynamic deleted;
 @dynamic uuid;
 @dynamic collected;
 @dynamic remote_id;
 @dynamic board;
 @dynamic user;
 @dynamic behavior;
*/

+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"deleted": @"deleted",
				@"transaction_id": @"transaction_id",
				@"remote_id": @"id",
				@"updated_date": @"updated_date",
				@"created_date": @"created_date",
				@"board": @"board",
			 };
}

@end
