#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+InfoDictionary.h"

@class SNFBehavior, SNFSmile;

NS_ASSUME_NONNULL_BEGIN

@interface SNFBoard : NSManagedObject


- (void)reset;
- (NSArray *)sortedActiveBehaviors;
- (NSArray *)sortedActiveRewards;

@end

NS_ASSUME_NONNULL_END

#import "SNFBoard+CoreDataProperties.h"
