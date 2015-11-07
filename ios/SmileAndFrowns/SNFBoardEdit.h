
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

@class SNFBoardEdit;

@protocol SNFBoardEditDelegate <NSObject>
- (void)boardEditor:(SNFBoardEdit *)be finishedWithBoard:(SNFBoard *)board;
@end

@interface SNFBoardEdit : SNFFormViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, SNFBoardEditBehaviorCellDelegate, SNFAddBehaviorDelegate, SNFAddCellDelegate, SNFAddRewardDelegate>{
	NSArray *_sortedBehaviors;
	NSArray *_sortedRewards;
}

@property (weak) IBOutlet UITextField *boardTitleField;
@property (weak) IBOutlet UITableView *behaviorsTable;
@property (weak) IBOutlet UICollectionView *rewardsCollectionView;
@property (weak) IBOutlet UILabel *rewardInfoLabel;
@property (weak) IBOutlet UIButton *addBehaviorButton;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) IBOutlet UIButton *useBoardButton;

@property (nonatomic) IBOutlet SNFBoard *board;
@property (weak) NSObject <SNFBoardEditDelegate> *delegate;

- (IBAction)onUpdateBoard:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;

@end
