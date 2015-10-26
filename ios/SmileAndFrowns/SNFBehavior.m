//
//  SNFBehavior.m
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/23/15.
//  Copyright © 2015 apptitude. All rights reserved.
//

#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBehavior


/*
 @property (nullable, nonatomic, retain) NSString *title;
 @property (nullable, nonatomic, retain) NSString *note;
 @property (nullable, nonatomic, retain) NSString *uuid;
 @property (nullable, nonatomic, retain) NSNumber *deleted;
 @property (nullable, nonatomic, retain) NSDate *created_date;
 @property (nullable, nonatomic, retain) NSDate *updated_date;
 @property (nullable, nonatomic, retain) NSNumber *remote_id;
 @property (nullable, nonatomic, retain) NSManagedObject *board;
 @property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
 @property (nullable, nonatomic, retain) NSManagedObject *frowns;
*/
+ (NSDictionary *)keyMappings{
	return @{
				@"uuid": @"uuid",
				@"title": @"title",
				@"note": @"note",
				@"deleted": @"deleted",
				@"created_date": @"created_date",
				@"updated_date": @"updated_date",
				@"remote_id": @"id",
			 };
}


@end
