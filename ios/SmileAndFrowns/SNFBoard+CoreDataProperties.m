#import "SNFBoard+CoreDataProperties.h"

#import "SNFReward.h"
#import "SNFUserRole.h"
#import "SNFInvite.h"
#import "SNFFrown.h"

@implementation SNFBoard (CoreDataProperties)

@dynamic uuid;
@dynamic updated_date;
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
