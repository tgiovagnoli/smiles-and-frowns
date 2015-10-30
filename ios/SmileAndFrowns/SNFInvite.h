
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SNFBoard;

NS_ASSUME_NONNULL_BEGIN

@interface SNFInvite : NSManagedObject

+ (NSArray *) all;

@end

NS_ASSUME_NONNULL_END

#import "SNFInvite+CoreDataProperties.h"
