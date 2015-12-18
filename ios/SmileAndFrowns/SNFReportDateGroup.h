
#import <Foundation/Foundation.h>
#import "SNFReportBehaviorGroup.h"

@interface SNFReportDateGroup : NSObject

@property NSInteger daysSinceEpoch;
@property NSDate * date;
@property NSInteger week;

@property NSMutableArray<SNFReportBehaviorGroup *> * behaviorGroups;

@end
