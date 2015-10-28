#import "SNFReward.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFReward (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *currency_amount;
@property (nullable, nonatomic, retain) NSNumber *smile_amount;
@property (nullable, nonatomic, retain) NSString *currency_type;


@end

NS_ASSUME_NONNULL_END
