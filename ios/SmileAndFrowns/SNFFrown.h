#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFBehavior, SNFBoard;

NS_ASSUME_NONNULL_BEGIN

@interface SNFFrown : NSManagedObject

+ (NSArray *)frownsSinceSyncDate:(NSDate *)syncDate withContext:(NSManagedObjectContext *)context;

@end

NS_ASSUME_NONNULL_END

#import "SNFFrown+CoreDataProperties.h"
