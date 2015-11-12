#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import "UIImage+Additions.h"

NS_ASSUME_NONNULL_BEGIN


#define SNFUserGenderUnknown @""
#define SNFUserGenderMale @"male"
#define SNFUserGenderFemale @"female"

@interface SNFUser : NSManagedObject

// use when the user info has been changed locally so that all user roles update
- (void)updateUserRolesForSyncWithContext:(NSManagedObjectContext *)context;
- (void)updateProfileImage:(UIImage *)image;
- (UIImage *)localImage;

@end

NS_ASSUME_NONNULL_END

#import "SNFUser+CoreDataProperties.h"
