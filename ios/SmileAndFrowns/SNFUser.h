#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN


#define SNFUserGenderUnknown @""
#define SNFUserGenderMale @"male"
#define SNFUserGenderFemale @"female"

@interface SNFUser : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "SNFUser+CoreDataProperties.h"
