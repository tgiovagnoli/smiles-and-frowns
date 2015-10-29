#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface SNFDateManager : NSObject

+ (void)lock;
+ (void)unlock;

@end
