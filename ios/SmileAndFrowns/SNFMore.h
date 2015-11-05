
#import <UIKit/UIKit.h>
#import "APDDebugViewController.h"
#import "MBProgressHUD.h"
#import "UIViewControllerStack.h"

@interface SNFMore : UIViewController <UITableViewDataSource, UITableViewDelegate, UIViewControllerStackUpdating> {
	NSArray *_tableContents;
}

@property (weak) IBOutlet UITableView *tableView;



@end
