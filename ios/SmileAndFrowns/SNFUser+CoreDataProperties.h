#import "SNFUser.h"

@class SNFSmile;
@class SNFFrown;
@class SNFUserRole;
@class SNFBoard;
@class SNFSpendableSmile;

NS_ASSUME_NONNULL_BEGIN

@interface SNFUser (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *first_name;
@property (nullable, nonatomic, retain) NSString *last_name;
@property (nullable, nonatomic, retain) NSString *image;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSNumber *age;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) NSString *tmp_profile_image_uuid;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSSet<SNFSpendableSmile *> *spendable_smiles;
@property (nullable, nonatomic, retain) NSSet<SNFSpendableSmile *> *spendable_smiles_creator;
@property (nullable, nonatomic, retain) NSSet<SNFFrown *> *frowns;
@property (nullable, nonatomic, retain) NSSet<SNFUserRole *> *user_roles;
@property (nullable, nonatomic, retain) NSSet<SNFBoard *> *owned_boards;


@end

NS_ASSUME_NONNULL_END
