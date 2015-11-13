#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import "APDDebugViewController.h"
#import "MBProgressHUD.h"
#import "UIViewControllerStack.h"
#import "IAPHelper.h"
#import "SNFMoreWebDetail.h"
#import "NSTimer+Blocks.h"

@interface SNFMore : UIViewController <UITableViewDataSource, UITableViewDelegate, UIViewControllerStackUpdating, MFMailComposeViewControllerDelegate> {
	NSArray *_tableContents;
}

@property (weak) IBOutlet UITableView *tableView;



@end
