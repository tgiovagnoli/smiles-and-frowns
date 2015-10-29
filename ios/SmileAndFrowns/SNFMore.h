#import <UIKit/UIKit.h>
#import "APDDebugViewController.h"

@interface SNFMore : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	NSArray *_tableContents;
}

@property (weak) IBOutlet UITableView *tableView;



@end
