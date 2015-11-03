//
//  SNFPredefinedBehaviorGroup+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 11/2/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFPredefinedBehaviorGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBehaviorGroup (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSSet<SNFPredefinedBehavior *> *behaviors;

@end

@interface SNFPredefinedBehaviorGroup (CoreDataGeneratedAccessors)

- (void)addBehaviorsObject:(SNFPredefinedBehavior *)value;
- (void)removeBehaviorsObject:(SNFPredefinedBehavior *)value;
- (void)addBehaviors:(NSSet<SNFPredefinedBehavior *> *)values;
- (void)removeBehaviors:(NSSet<SNFPredefinedBehavior *> *)values;

@end

NS_ASSUME_NONNULL_END