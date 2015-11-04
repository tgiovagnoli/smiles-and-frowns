#import <UIKit/UIKit.h>
#import "SNFReward.h"

@interface SNFRewardCell : UICollectionViewCell

@property (weak) IBOutlet UILabel *titleLabel;
@property (nonatomic) SNFReward *reward;

@end
