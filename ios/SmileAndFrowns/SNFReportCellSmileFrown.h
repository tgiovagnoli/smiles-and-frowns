#import <UIKit/UIKit.h>
#import "SNFReportBehaviorGroup.h"

@interface SNFReportCellSmileFrown : UITableViewCell

@property (weak) IBOutlet UILabel *countLabel;
@property (weak) IBOutlet UILabel *behaviorLabel;
@property (weak) IBOutlet UILabel *creatorLabel;
@property (weak) IBOutlet UILabel *noteLabel;
@property (weak) IBOutlet UIImageView *smileFrownImageView;

@property (nonatomic) SNFReportBehaviorGroup *behaviorGroup;



@end