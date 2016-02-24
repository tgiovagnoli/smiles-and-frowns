
#import <UIKit/UIKit.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFReportBehaviorGroup.h"
#import "SNFReportDateGroup.h"
#import "HDLabel.h"
#import "SNFReportDataProvider.h"
#import "SNFReportSection.h"
#import "SNFReportBehaviorGroup2.h"

extern NSString * const SNFReportPDFFinished;

@interface SNFReportPDF : UIViewController

@property SNFUser * user;
@property SNFBoard * board;
@property SNFReportDataProvider * dataProvider;
@property NSArray <SNFReportDateGroup *> * dataProviderV1;

@property IBOutlet HDLabel * credits;

- (void) savePDF;

@end
