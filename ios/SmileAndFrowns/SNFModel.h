#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface SNFModel : NSObject

@property NSManagedObjectContext *managedObjectContext;

+ (SNFModel *)sharedInstance;

@end
