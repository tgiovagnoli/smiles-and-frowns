#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBoard

/*
 @property (nullable, nonatomic, retain) NSString *uuid;
 @property (nullable, nonatomic, retain) NSDate *updated_date;
 @property (nullable, nonatomic, retain) NSNumber *deleted;
 @property (nullable, nonatomic, retain) NSString *title;
 @property (nullable, nonatomic, retain) NSString *transaction_id;
 @property (nullable, nonatomic, retain) NSDate *created_date;
 @property (nullable, nonatomic, retain) NSNumber *remote_id;
 @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *frowns;
 @property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
 @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *rewards;
 @property (nullable, nonatomic, retain) NSSet<SNFBehavior *> *behaviors;
 @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *user_roles;
 @property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *invites;
*/

+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"title": @"title",
				@"deleted": @"deleted",
				@"transaction_id": @"transaction_id",
				@"remote_id": @"id",
				@"updated_date": @"updated_date",
				@"created_date": @"created_date",
				@"edit_count": @"edit_count",
			 };
}




@end
