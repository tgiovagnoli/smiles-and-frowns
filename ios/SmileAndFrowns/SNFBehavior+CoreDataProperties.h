//
//  SNFBehavior+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/23/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFBehavior.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFBehavior (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *modified_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) NSManagedObject *board;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSManagedObject *frowns;

@end

@interface SNFBehavior (CoreDataGeneratedAccessors)

- (void)addSmilesObject:(SNFSmile *)value;
- (void)removeSmilesObject:(SNFSmile *)value;
- (void)addSmiles:(NSSet<SNFSmile *> *)values;
- (void)removeSmiles:(NSSet<SNFSmile *> *)values;

@end

NS_ASSUME_NONNULL_END
