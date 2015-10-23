//
//  SNFFrown+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/23/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFFrown.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFFrown (CoreDataProperties)

@property (nullable, nonatomic, retain) NSDate *modified_date;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) NSManagedObject *user;
@property (nullable, nonatomic, retain) SNFBehavior *behavior;

@end

NS_ASSUME_NONNULL_END
