#import <Foundation/Foundation.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportDateGroup.h"
#import "SNFReportBehaviorGroup.h"

@interface SNFReportGeneration : NSObject

- (NSArray <SNFReportBehaviorGroup *> *)smilesFrownsReportForUser:(SNFUser *)user board:(SNFBoard *)board ascending:(BOOL)ascending;

@end
