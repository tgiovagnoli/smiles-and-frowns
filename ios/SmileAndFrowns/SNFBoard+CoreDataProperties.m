//
//  SNFBoard+CoreDataProperties.m
//  SmileAndFrowns
//
//  Created by Malcolm Wilson on 10/23/15.
//  Copyright © 2015 apptitude. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "SNFBoard+CoreDataProperties.h"

@implementation SNFBoard (CoreDataProperties)

@dynamic uuid;
@dynamic modified_date;
@dynamic deleted;
@dynamic title;
@dynamic transaction_id;
@dynamic created_date;
@dynamic remote_id;
@dynamic frowns;
@dynamic smiles;
@dynamic rewards;
@dynamic behaviors;
@dynamic user_roles;
@dynamic invites;

@end
