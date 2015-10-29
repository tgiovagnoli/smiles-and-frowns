//
//  SNFPredefinedBoard+CoreDataProperties.h
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/29/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFPredefinedBoard.h"

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBoard (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;

@end

NS_ASSUME_NONNULL_END
