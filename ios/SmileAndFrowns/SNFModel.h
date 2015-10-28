#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SNFConfig.h"
#import "SNFUser.h"

@interface SNFModel : NSObject

@property NSManagedObjectContext *managedObjectContext;
@property (readonly) SNFConfig *config;
@property SNFUser *loggedInUser;

+ (SNFModel *)sharedInstance;

@end
