
#import <Foundation/Foundation.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportDateGroup.h"
#import "SNFReportBehaviorGroup.h"
#import "SNFReportDataProvider.h"

@interface SNFReportGeneration : NSObject

- (SNFReportDataProvider *) smilesFrownsReportByWeeksForUser:(SNFUser *)user board:(SNFBoard *) board;
- (NSArray <SNFReportDateGroup *> *)smilesFrownsReportForUser:(SNFUser *)user board:(SNFBoard *)board ascending:(BOOL)ascending;

@end
