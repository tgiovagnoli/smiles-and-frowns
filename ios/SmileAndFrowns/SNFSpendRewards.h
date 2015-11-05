#import <UIKit/UIKit.h>
#import "UIAlertAction+Additions.h"
#import "SNFAddReward.h"
#import "SNFBoard.h"
#import "SNFUser.h"
#import "SNFRewardCell.h"
#import "SNFAddCell.h"
#import "SNFSmile.h"
#import "SNFFrown.h"

@class SNFSpendRewards;

@protocol SNFSpendRewardsDelegate <NSObject>
- (void)spendRewardsIsDone:(SNFSpendRewards *)spendRewards;
@end

@interface SNFSpendRewards : UIViewController <UICollectionViewDataSource, UICollectionViewDataSource, SNFAddCellDelegate, SNFAddRewardDelegate>{
	NSArray *_sortedRewards;
	NSInteger _smilesAvailable;
	SNFReward *_selectedReward;
}

@property (weak) IBOutlet UILabel *userFirstLastLabel;
@property (weak) IBOutlet UILabel *userGenderAgeLabel;
@property (weak) IBOutlet UILabel *totalSmilestoSpendLabel;
@property (weak) IBOutlet UIImageView *userProfileImageView;
@property (weak) IBOutlet UICollectionView *rewardsCollection;
@property (weak) IBOutlet UILabel *rewardsInfoLabel;
@property (weak) IBOutlet UIStepper *incrementStepper;
@property (weak) IBOutlet UIButton *maxButton;
@property (weak) IBOutlet UILabel *spendSmilesLabel;
@property (weak) IBOutlet UILabel *rewardCalculatedLabel;
@property (weak) IBOutlet UIButton *spendSmileButton;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) NSObject <SNFSpendRewardsDelegate> *delegate;

@property (nonatomic) SNFBoard *board;
@property (nonatomic) SNFUser *user;

- (IBAction)onRewardModifierChange:(UIStepper *)sender;
- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onRedeemReward:(UIButton *)sender;
- (IBAction)onMax:(UIButton *)sender;

@end