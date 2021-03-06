#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFPredefinedBoard;
@class SNFPredefinedBehaviorGroup;

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBehavior : NSManagedObject

+ (SNFPredefinedBehavior *) behaviorByUUID:(NSString *) uuid;
+ (SNFPredefinedBehaviorGroup *) groupForBehavior:(SNFPredefinedBehavior *) behavior;

@end

NS_ASSUME_NONNULL_END

#import "SNFPredefinedBehavior+CoreDataProperties.h"