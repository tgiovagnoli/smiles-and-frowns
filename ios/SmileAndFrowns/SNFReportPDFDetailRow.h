
#import <UIKit/UIKit.h>
#import "SNFReportBehaviorGroup.h"

@interface SNFReportPDFDetailRow : UIViewController

@property SNFReportBehaviorGroup * behaviorGroup;

@property IBOutlet UIImageView * imageView;
@property IBOutlet UILabel * smileFrownCount;
@property IBOutlet UILabel * behavior;
@property IBOutlet UILabel * user;
@property IBOutlet UILabel * note;
@property IBOutlet UIView * seperator;

- (void) hideSeperator;

@end
