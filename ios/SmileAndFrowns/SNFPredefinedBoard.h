
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFPredefinedBehavior;

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBoard : NSManagedObject

+ (SNFPredefinedBoard *) boardByUUID:(NSString *) uuid;

@end

NS_ASSUME_NONNULL_END

#import "SNFPredefinedBoard+CoreDataProperties.h"
