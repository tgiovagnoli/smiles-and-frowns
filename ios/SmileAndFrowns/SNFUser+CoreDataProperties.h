#import "SNFUser.h"

@class SNFSmile;
@class SNFFrown;
@class SNFUserRole;

NS_ASSUME_NONNULL_BEGIN

@interface SNFUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *first_name;
@property (nullable, nonatomic, retain) NSString *last_name;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSSet<SNFFrown *> *frowns;
@property (nullable, nonatomic, retain) NSSet<SNFUserRole *> *user_roles;

@end

NS_ASSUME_NONNULL_END
