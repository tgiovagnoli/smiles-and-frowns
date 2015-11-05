
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "UIViewControllerStack.h"

@interface SNFInvites : UIViewController <UITableViewDataSource,UITableViewDelegate,UIViewControllerStackUpdating>

@property (weak) IBOutlet UITableView * tableView;

@end
