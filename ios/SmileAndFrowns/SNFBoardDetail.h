
#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "SNFUserRole.h"
#import "SNFBoardDetailAdultCell.h"
#import "SNFBoardDetailChildCell.h"
#import "SNFAddUserRole.h"
#import "SNFAddSmileOrFrown.h"
#import "SNFSpendRewards.h"
#import "SNFReporting.h"
#import "UIViewControllerStack.h"
#import "SNFChildEdit.h"


typedef NS_ENUM(NSInteger, SNFBoardDetailUserRole){
	SNFBoardDetailUserRoleOwner,
	SNFBoardDetailUserRoleChildren,
	SNFBoardDetailUserRoleParents,
	SNFBoardDetailUserRoleGuardians,
};


@interface SNFBoardDetail : UIViewController <UIViewControllerStackUpdating, UITableViewDelegate, UITableViewDataSource, SNFBoardDetailChildCellDelegate, SNFAddSmileOrFrownDelegate, SNFSpendRewardsDelegate, SNFBoardDetailAdultCellDelegate, SNFChildEditDelegate> {
	NSArray *_userRoles;
	
	NSArray *_children;
	NSArray *_parents;
	NSArray *_guardians;
}

@property (weak) IBOutlet UITableView * rolesTable;
@property (weak) IBOutlet UIButton * addButton;
@property (weak) IBOutlet UIButton * backButton;
@property (weak) IBOutlet UILabel * titleLabel;
@property (weak) IBOutlet NSLayoutConstraint * addButtonHeightConstraint;
@property (nonatomic) SNFBoard * board;

- (IBAction)backToBoards:(UIButton *)sender;

@end
