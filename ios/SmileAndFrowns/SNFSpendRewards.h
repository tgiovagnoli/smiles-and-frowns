
#import <UIKit/UIKit.h>
#import "UIAlertAction+Additions.h"
#import "SNFAddReward.h"
#import "SNFBoard.h"
#import "SNFUser.h"
#import "SNFRewardCell.h"
#import "SNFAddCell.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFFormViewController.h"

@class SNFSpendRewards;

@protocol SNFSpendRewardsDelegate <NSObject>
- (void)spendRewardsIsDone:(SNFSpendRewards *)spendRewards;
@end

@interface SNFSpendRewards : SNFFormViewController <UICollectionViewDataSource, UICollectionViewDataSource, SNFAddCellDelegate, SNFAddRewardDelegate> {
	NSArray *_sortedRewards;
	NSInteger _smilesAvailable;
	SNFReward *_selectedReward;
}

@property (weak) IBOutlet UIImageView * userProfileImageView;
@property (weak) IBOutlet UILabel * userFirstLastLabel;
@property (weak) IBOutlet UILabel * userGenderAgeLabel;
@property (weak) IBOutlet UIView * spendCountView;
@property (weak) IBOutlet UILabel * totalSmilestoSpendLabel;
@property (weak) IBOutlet UIImageView * totalSmilesImage;

@property (weak) IBOutlet UIButton * addRewardButton;
@property (weak) IBOutlet UICollectionView * rewardsCollection;

@property (weak) IBOutlet UIView * rewardsViewContainer;
@property IBOutlet UIView * rewardsView;
@property (weak) IBOutlet NSLayoutConstraint * rewardsLeftConstraint;
@property (weak) IBOutlet NSLayoutConstraint * rewardsWidthConstraint;
@property IBOutlet UIImageView * smileImage;
@property (weak) IBOutlet NSLayoutConstraint * smileImageCenterConstraint;
@property IBOutlet UILabel * rewardsInfoLabel;
@property (weak) IBOutlet UIButton * deleteButton;

@property (weak) IBOutlet UIView * spendAmountView;
@property (weak) IBOutlet UIButton * addButton;
@property (weak) IBOutlet UIButton * subtractButton;
@property (weak) IBOutlet UIImageView * spendCountSmileImage;
@property (weak) IBOutlet UIButton * maxButton;
@property (weak) IBOutlet UILabel * spendSmilesLabel;
@property (weak) IBOutlet UILabel * rewardCalculatedLabel;
@property (weak) IBOutlet UIButton * spendSmileButton;
@property (weak) IBOutlet UIButton * cancelButton;

@property (weak) NSObject <SNFSpendRewardsDelegate> *delegate;

@property (nonatomic) SNFBoard *board;
@property (nonatomic) SNFUser *user;

- (IBAction)onRewardModifierChange:(UIStepper *)sender;
- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onRedeemReward:(UIButton *)sender;
- (IBAction)onMax:(UIButton *)sender;

@end
