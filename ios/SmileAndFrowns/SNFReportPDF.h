
#import <UIKit/UIKit.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFReportBehaviorGroup.h"
#import "SNFReportDateGroup.h"
#import "HDLabel.h"

extern NSString * const SNFReportPDFFinished;

@interface SNFReportPDF : UIViewController

@property SNFUser * user;
@property SNFBoard * board;
@property NSArray <SNFReportDateGroup *> * reportData;

@property IBOutlet HDLabel * credits;

- (void) savePDF;

@end