
#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "NSString+Additions.h"
#import "SNFBoardEditBehaviorCell.h"
#import "SNFAddBehavior.h"
#import "SNFRewardCell.h"
#import "SNFAddCell.h"
#import "SNFAddReward.h"
#import "SNFFormViewController.h"
#import "UIView+AutoLayout.h"
#import "NSTimer+Blocks.h"
#import "UIColor+Hex.h"
#import "SNFFormStyles.h"

extern NSString * const SNFBoardEditFinished;

@class SNFBoardEdit;

typedef NS_ENUM(NSInteger, SNFBoardEditBehaviorType){
	SNFBoardEditBehaviorTypePositive,
	SNFBoardEditBehaviorTypeNegative
};

@protocol SNFBoardEditDelegate <NSObject>
- (void)boardEditor:(SNFBoardEdit *)be finishedWithBoard:(SNFBoard *)board;
@end

@interface SNFBoardEdit : SNFFormViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SNFBoardEditBehaviorCellDelegate, SNFAddBehaviorDelegate, SNFAddCellDelegate, SNFAddRewardDelegate>{
	NSArray *_sortedRewards;
	NSArray *_positiveBehaviors;
	NSArray *_negativeBehaviors;
}

@property (weak) IBOutlet UITextField *boardTitleField;
@property (weak) IBOutlet UITableView *behaviorsTable;
@property (weak) IBOutlet UICollectionView *rewardsCollectionView;
@property (weak) IBOutlet UILabel *rewardInfoLabel;
@property (weak) IBOutlet UIButton *addBehaviorButton;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) IBOutlet UIButton *useBoardButton;
@property (weak) IBOutlet UIButton * addRewardButton;
@property IBOutlet UIView *noBehaviorsMessage;

@property (nonatomic) SNFBoard *board;

@property (weak) NSObject <SNFBoardEditDelegate> *delegate;

- (IBAction)onUpdateBoard:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;

@end
