#import "SNFSmile.h"


NS_ASSUME_NONNULL_BEGIN

@class SNFBoard;
@class SNFUser;
@class SNFBehavior;

@interface SNFSmile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *collected;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) SNFUser *user;
@property (nullable, nonatomic, retain) SNFUser *creator;
@property (nullable, nonatomic, retain) SNFBehavior *behavior;

@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *device_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;

@end

NS_ASSUME_NONNULL_END
