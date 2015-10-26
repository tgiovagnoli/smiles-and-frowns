@class SNFInvite;

#import "SNFUserRole.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFUserRole (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *role;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFUser *user;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) NSSet<SNFInvite *> *invites;


@end

NS_ASSUME_NONNULL_END
