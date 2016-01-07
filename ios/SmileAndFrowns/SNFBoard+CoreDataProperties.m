#import "SNFBoard+CoreDataProperties.h"

#import "SNFReward.h"
#import "SNFUserRole.h"
#import "SNFFrown.h"
#import "SNFUser.h"

@implementation SNFBoard (CoreDataProperties)

@dynamic uuid;
@dynamic predefined_board_uuid;
@dynamic owner;
@dynamic updated_date;
@dynamic soft_deleted;
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
@dynamic device_date;

@end
