#import <Foundation/Foundation.h>
#import "SNFReportBehaviorGroup.h"

@interface SNFReportDateGroup : NSObject

@property NSInteger daysSinceEpoch;
@property NSDate *date;
@property NSMutableArray<SNFReportBehaviorGroup *> *behaviorGroups;

@end
