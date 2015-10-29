#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFBoard;

#define SNFRewardCurrencyTypeMoney @"money"
#define SNFRewardCurrencyTypeTime @"time"
#define SNFRewardCurrencyTypeTreat @"treat"
#define SNFRewardCurrencyTypeGoal @"goal"

NS_ASSUME_NONNULL_BEGIN

@interface SNFReward : NSManagedObject


@end

NS_ASSUME_NONNULL_END

#import "SNFReward+CoreDataProperties.h"
