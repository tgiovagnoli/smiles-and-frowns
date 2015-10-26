#import "SNFFrown.h"

@class SNFUser;

NS_ASSUME_NONNULL_BEGIN

@interface SNFFrown (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) SNFUser *user;
@property (nullable, nonatomic, retain) SNFBehavior *behavior;

@end

NS_ASSUME_NONNULL_END
