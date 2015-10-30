#import "SNFInvite.h"

@class SNFUserRole;

NS_ASSUME_NONNULL_BEGIN

@interface SNFInvite (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString * uuid;
@property (nullable, nonatomic, retain) NSNumber * remote_id;
@property (nullable, nonatomic, retain) NSString * board_uuid;
@property (nullable, nonatomic, retain) NSString * board_title;
@property (nullable, nonatomic, retain) NSString * code;
@property (nullable, nonatomic, retain) NSString * sender_first_name;
@property (nullable, nonatomic, retain) NSString * sender_last_name;
@property (nullable, nonatomic, retain) NSDate * created_date;

@end

NS_ASSUME_NONNULL_END
