#import <UIKit/UIKit.h>

@interface SNFBoardList : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak) IBOutlet UITableView *boardstable;
@property (weak) IBOutlet UISegmentedControl *filterControl;
@property (weak) IBOutlet UIButton *searchButton;
@property (weak) IBOutlet UIButton *purchaseButton;

@end
