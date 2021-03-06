
#import "SNFUser+CoreDataProperties.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFUserRole.h"
#import "SNFSpendableSmile.h"

@implementation SNFUser (CoreDataProperties)

@dynamic username;
@dynamic first_name;
@dynamic last_name;
@dynamic image;
@dynamic email;
@dynamic age;
@dynamic gender;
@dynamic tmp_profile_image_uuid;
@dynamic remote_id;
@dynamic smiles;
@dynamic frowns;
@dynamic user_roles;
@dynamic owned_boards;
@dynamic spendable_smiles;
@dynamic spendable_smiles_creator;

@end
