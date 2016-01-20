//
//  SNFPredefinedBehavior+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 11/2/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFPredefinedBehavior.h"
#import "SNFPredefinedBehaviorGroup.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBehavior (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *group;
@property (nullable, nonatomic, retain) NSNumber *soft_delete;
@property (nullable, nonatomic, retain) NSNumber *positive;
@property (nullable, nonatomic, retain) NSSet<SNFPredefinedBoard *> * predefined_boards;
@property (nullable, nonatomic, retain) NSSet<SNFPredefinedBehaviorGroup *> * predefined_behaviors;

@end

@interface SNFPredefinedBehavior (CoreDataGeneratedAccessors)

- (void)addPredefined_boardsObject:(SNFPredefinedBoard *)value;
- (void)removePredefined_boardsObject:(SNFPredefinedBoard *)value;
- (void)addPredefined_boards:(NSSet<SNFPredefinedBoard *> *)values;
- (void)removePredefined_boards:(NSSet<SNFPredefinedBoard *> *)values;

- (void)addPredefined_behaviorsObject:(SNFPredefinedBehaviorGroup *)value;
- (void)removePredefined_behaviorsObject:(SNFPredefinedBehaviorGroup *)value;
- (void)addPredefined_behaviors:(NSSet<SNFPredefinedBehaviorGroup *> *)values;
- (void)removePredefined_behaviors:(NSSet<SNFPredefinedBehaviorGroup *> *)values;

@end

NS_ASSUME_NONNULL_END
