
#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportBehaviorGroup2.h"

@interface SNFReportSection : NSObject

@property NSInteger weeks;
@property NSTimeInterval start;
@property NSTimeInterval end;
@property NSMutableArray * behaviorGroups;

- (BOOL) wasCreatedInWindow:(NSDate *) createdDate;
- (void) addSmile:(SNFSmile *) smile;
- (void) addFrown:(SNFFrown *) frown;

@end
