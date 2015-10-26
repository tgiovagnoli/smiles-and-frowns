#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFBoard.h"

@implementation SNFFrown

/*
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) NSManagedObject *user;
@property (nullable, nonatomic, retain) SNFBehavior *behavior;
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
