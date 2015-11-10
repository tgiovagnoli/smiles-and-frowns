
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewControllerStack.h"
#import "SNFFormViewController.h"

@interface SNFInvites : SNFFormViewController <UITableViewDataSource,UITableViewDelegate,UIViewControllerStackUpdating,UITextFieldDelegate>

@property (weak) IBOutlet UITableView * tableView;
@property (weak) IBOutlet UITextField * search;
@property (weak) IBOutlet UISegmentedControl * segment;
@property (weak) IBOutlet UIButton * searchButton;
@property IBOutlet NSLayoutConstraint * tableViewBottom;

@end
