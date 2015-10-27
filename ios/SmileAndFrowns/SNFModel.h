#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SNFConfig.h"

@interface SNFModel : NSObject

@property NSManagedObjectContext *managedObjectContext;
@property (readonly) SNFConfig *config;

+ (SNFModel *)sharedInstance;

@end
