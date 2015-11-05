#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+InfoDictionary.h"

@class SNFBehavior, SNFSmile, SNFUser, SNFSmile, SNFFrown;

NS_ASSUME_NONNULL_BEGIN

@interface SNFBoard : NSManagedObject


- (void)reset;
- (NSArray *)sortedActiveBehaviors;
- (NSArray *)sortedActiveRewards;
- (NSArray *)smilesForUser:(SNFUser *)user;
- (NSArray *)frownsForUser:(SNFUser *)user;
- (NSInteger)smileCurrencyForUser:(SNFUser *)user;

@end

NS_ASSUME_NONNULL_END

#import "SNFBoard+CoreDataProperties.h"
