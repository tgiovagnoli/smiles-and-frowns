#import "SNFBoard.h"

@class SNFReward;
@class SNFUserRole;
@class SNFInvite;
@class SNFFrown;
@class SNFUser;
@class SNFSpendableSmile;

NS_ASSUME_NONNULL_BEGIN

@interface SNFBoard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *transaction_id;

@property (nullable, nonatomic, retain) SNFUser *owner;
@property (nullable, nonatomic, retain) NSSet<SNFFrown *> *frowns;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSSet<SNFSpendableSmile *> *spendable_smiles;
@property (nullable, nonatomic, retain) NSSet<SNFReward *> *rewards;
@property (nullable, nonatomic, retain) NSSet<SNFBehavior *> *behaviors;
@property (nullable, nonatomic, retain) NSSet<SNFUserRole *> *user_roles;
@property (nullable, nonatomic, retain) NSSet<SNFInvite *> *invites;

@property (nullable, nonatomic, retain) NSNumber *soft_deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *predefined_board_uuid;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSDate *device_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;

@end

@interface SNFBoard (CoreDataGeneratedAccessors)

- (void)addFrownsObject:(SNFFrown *)value;
- (void)removeFrownsObject:(SNFFrown *)value;
- (void)addFrowns:(NSSet<SNFFrown *> *)values;
- (void)removeFrowns:(NSSet<SNFFrown *> *)values;

- (void)addSmilesObject:(SNFSmile *)value;
- (void)removeSmilesObject:(SNFSmile *)value;
- (void)addSmiles:(NSSet<SNFSmile *> *)values;
- (void)removeSmiles:(NSSet<SNFSmile *> *)values;

- (void)addSpendable_smilesObject:(SNFSpendableSmile *)object;
- (void)removeSpendable_smilesObject:(SNFSpendableSmile	*)object;
- (void)addSpendable_smiles:(NSSet <SNFSpendableSmile *> *)objects;
- (void)removeSpendable_smiles:(NSSet <SNFSpendableSmile *> *)objects;

- (void)addRewardsObject:(SNFReward *)value;
- (void)removeRewardsObject:(SNFReward *)value;
- (void)addRewards:(NSSet<SNFReward *> *)values;
- (void)removeRewards:(NSSet<SNFReward *> *)values;

- (void)addBehaviorsObject:(SNFBehavior *)value;
- (void)removeBehaviorsObject:(SNFBehavior *)value;
- (void)addBehaviors:(NSSet<SNFBehavior *> *)values;
- (void)removeBehaviors:(NSSet<SNFBehavior *> *)values;

- (void)addUser_rolesObject:(SNFUserRole *)value;
- (void)removeUser_rolesObject:(SNFUserRole *)value;
- (void)addUser_roles:(NSSet<SNFUserRole *> *)values;
- (void)removeUser_roles:(NSSet<SNFUserRole *> *)values;

- (void)addInvitesObject:(SNFInvite *)value;
- (void)removeInvitesObject:(SNFInvite *)value;
- (void)addInvites:(NSSet<SNFInvite *> *)values;
- (void)removeInvites:(NSSet<SNFInvite *> *)values;

@end

NS_ASSUME_NONNULL_END
