
#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "SNFUserRole.h"
#import "SNFBoardDetailAdultCell.h"
#import "SNFBoardDetailChildCell.h"
#import "SNFAddUserRole.h"
#import "SNFAddSmileOrFrown.h"

@interface SNFBoardDetail : UIViewController <UITableViewDelegate, UITableViewDataSource, SNFBoardDetailChildCellDelegate, SNFAddSmileOrFrownDelegate>{
	NSArray * _userRoles;
}

@property (weak) IBOutlet UITableView *rolesTable;
@property (weak) IBOutlet UIButton *addButton;
@property (weak) IBOutlet UIButton *backButton;
@property (weak) IBOutlet UILabel *titleLabel;

@property (nonatomic) SNFBoard *board;

- (IBAction)backToBoards:(UIButton *)sender;

@end
