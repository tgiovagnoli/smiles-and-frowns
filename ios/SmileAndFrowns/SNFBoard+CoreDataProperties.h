//
//  SNFBoard+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/23/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFBoard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFBoard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSDate *modified_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *transaction_id;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *frowns;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *rewards;
@property (nullable, nonatomic, retain) NSSet<SNFBehavior *> *behaviors;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *user_roles;
@property (nullable, nonatomic, retain) NSSet<NSManagedObject *> *invites;

@end

@interface SNFBoard (CoreDataGeneratedAccessors)

- (void)addFrownsObject:(NSManagedObject *)value;
- (void)removeFrownsObject:(NSManagedObject *)value;
- (void)addFrowns:(NSSet<NSManagedObject *> *)values;
- (void)removeFrowns:(NSSet<NSManagedObject *> *)values;

- (void)addSmilesObject:(SNFSmile *)value;
- (void)removeSmilesObject:(SNFSmile *)value;
- (void)addSmiles:(NSSet<SNFSmile *> *)values;
- (void)removeSmiles:(NSSet<SNFSmile *> *)values;

- (void)addRewardsObject:(NSManagedObject *)value;
- (void)removeRewardsObject:(NSManagedObject *)value;
- (void)addRewards:(NSSet<NSManagedObject *> *)values;
- (void)removeRewards:(NSSet<NSManagedObject *> *)values;

- (void)addBehaviorsObject:(SNFBehavior *)value;
- (void)removeBehaviorsObject:(SNFBehavior *)value;
- (void)addBehaviors:(NSSet<SNFBehavior *> *)values;
- (void)removeBehaviors:(NSSet<SNFBehavior *> *)values;

- (void)addUser_rolesObject:(NSManagedObject *)value;
- (void)removeUser_rolesObject:(NSManagedObject *)value;
- (void)addUser_roles:(NSSet<NSManagedObject *> *)values;
- (void)removeUser_roles:(NSSet<NSManagedObject *> *)values;

- (void)addInvitesObject:(NSManagedObject *)value;
- (void)removeInvitesObject:(NSManagedObject *)value;
- (void)addInvites:(NSSet<NSManagedObject *> *)values;
- (void)removeInvites:(NSSet<NSManagedObject *> *)values;

@end

NS_ASSUME_NONNULL_END
