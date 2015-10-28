#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SNFConfig.h"
#import "SNFUser.h"
#import "SNFUserSettings.h"

@interface SNFModel : NSObject

@property NSManagedObjectContext *managedObjectContext;
@property (readonly) SNFConfig *config;
@property (readonly) SNFUserSettings *userSettings;
@property SNFUser *loggedInUser;


+ (SNFModel *)sharedInstance;

@end
