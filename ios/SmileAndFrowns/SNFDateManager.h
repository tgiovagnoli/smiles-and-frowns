#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SNFDateManager : NSObject

+ (BOOL)isLocked;
+ (void)lock;
+ (void)unlock;

@end
