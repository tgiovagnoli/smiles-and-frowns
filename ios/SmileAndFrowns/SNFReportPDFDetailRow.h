
#import <UIKit/UIKit.h>
#import "SNFReportBehaviorGroup.h"
#import "SNFReportBehaviorGroup2.h"

@interface SNFReportPDFDetailRow : UIViewController

@property SNFReportBehaviorGroup2 * behaviorGroup;
@property SNFReportBehaviorGroup * behaviorGroupV1;

@property IBOutlet UIImageView * imageView;
@property IBOutlet UILabel * smileFrownCount;
@property IBOutlet UILabel * behavior;
@property IBOutlet UILabel * user;
@property IBOutlet UILabel * note;
@property IBOutlet UIView * seperator;

- (void) hideSeperator;

@end
