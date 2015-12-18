
#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportBehaviorGroup2.h"

@interface SNFReportSection : NSObject

@property NSInteger sectionIndex;
@property NSString * sectionHeaderTitle;
@property NSMutableArray * behaviorGroups;

- (void) addSmile:(SNFSmile *) smile;
- (void) addFrown:(SNFFrown *) frown;

@end
