#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFPredefinedBehavior;

#define SNFPredefinedBehaviorGroupUserName @"User Created"

NS_ASSUME_NONNULL_BEGIN

@interface SNFPredefinedBehaviorGroup : NSManagedObject

@property (readonly, nonatomic) NSArray *positiveBehaviors;
@property (readonly, nonatomic) NSArray *negativeBehaviors;

@end

NS_ASSUME_NONNULL_END

#import "SNFPredefinedBehaviorGroup+CoreDataProperties.h"
