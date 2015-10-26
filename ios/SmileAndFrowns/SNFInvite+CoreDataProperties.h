#import "SNFInvite.h"

@class SNFUserRole;

NS_ASSUME_NONNULL_BEGIN

@interface SNFInvite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) SNFUserRole *role;
@property (nullable, nonatomic, retain) NSString *code;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;

@end

NS_ASSUME_NONNULL_END
