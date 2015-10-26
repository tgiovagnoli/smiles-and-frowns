#import "SNFReward.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFReward (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;

@end

NS_ASSUME_NONNULL_END
