
#import <UIKit/UIKit.h>
#import "SNFReportBehaviorGroup.h"
#import "SNFReportBehaviorGroup2.h"
#import "SNFReportSection.h"

@interface SNFReportCellSmileFrown : UITableViewCell

@property (weak) IBOutlet UILabel * countLabel;
@property (weak) IBOutlet UILabel * behaviorLabel;
@property (weak) IBOutlet UILabel * creatorLabel;
@property (weak) IBOutlet UILabel * noteLabel;
@property (weak) IBOutlet UIImageView * smileFrownImageView;

@property (nonatomic) SNFReportBehaviorGroup2 * behaviorGroup;
- (void) setBehaviorGroupV1:(SNFReportBehaviorGroup *) behaviorGroup;

@end
