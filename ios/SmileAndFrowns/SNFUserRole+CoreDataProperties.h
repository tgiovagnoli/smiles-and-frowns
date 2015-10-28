@class SNFInvite;

#import "SNFUserRole.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFUserRole (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) SNFUser *user;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) NSSet<SNFInvite *> *invites;

@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *device_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;

@end

NS_ASSUME_NONNULL_END
