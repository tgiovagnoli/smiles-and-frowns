//
//  SNFSpendableSmile+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Aaron Smith on 1/21/16.
//  Copyright © 2016 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFSpendableSmile.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFSpendableSmile (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *collected;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *device_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) NSNumber *soft_deleted;
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) SNFUser *creator;
@property (nullable, nonatomic, retain) SNFUser *user;

@end

NS_ASSUME_NONNULL_END
