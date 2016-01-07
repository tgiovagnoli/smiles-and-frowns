#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "NSManagedObject+InfoDictionary.h"

@class SNFBehavior, SNFSmile, SNFUser, SNFSmile, SNFFrown, SNFPredefinedBoard;

NS_ASSUME_NONNULL_BEGIN


@interface SNFBoard : NSManagedObject

+ (SNFBoard *)boardByUUID:(NSString *) uuid;
+ (SNFBoard *)boardFromPredefinedBoard:(SNFPredefinedBoard *)pdb andContext:(NSManagedObjectContext *)context;
- (void)addInitialRewards;
- (void)reset;
- (NSArray *)sortedActiveBehaviors;
- (NSArray *)sortedActivePositiveBehaviors;
- (NSArray *)sortedActiveNegativeBehaviors;
- (NSArray *)sortedActiveRewards;
- (NSArray *)smilesForUser:(SNFUser *)user includeDeletedSmiles:(BOOL) includeDeletedSmiles includeCollectedSmiles:(BOOL) includeCollectedSmiles;
- (NSArray *)frownsForUser:(SNFUser *)user includeDeletedFrowns:(BOOL) includeDeletedFrowns;
- (NSInteger)smileCurrencyForUser:(SNFUser *)user;
- (NSString *)permissionForUser:(SNFUser *)user;


//this looks up a SNFPredefinedBoard based on the predefined_board_uuid, then returns all of it's associated behaviors.
- (NSArray *) predefinedBoardBehaviors;

@end

NS_ASSUME_NONNULL_END

#import "SNFBoard+CoreDataProperties.h"
