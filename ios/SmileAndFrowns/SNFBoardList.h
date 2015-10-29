#import <UIKit/UIKit.h>

@interface SNFBoardList : UIViewController <UITableViewDelegate, UITableViewDataSource>{
	NSArray *_boards;
}

@property (weak) IBOutlet UITableView *boardsTable;
@property (weak) IBOutlet UISegmentedControl *filterControl;
@property (weak) IBOutlet UIButton *searchButton;
@property (weak) IBOutlet UIButton *purchaseButton;

@end
