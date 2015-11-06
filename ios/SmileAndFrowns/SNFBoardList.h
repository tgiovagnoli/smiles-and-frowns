
#import <UIKit/UIKit.h>
#import "SNFBoardListCell.h"
#import "SNFPredefinedBoardCell.h"
#import "SNFBoardEdit.h"
#import "SNFPredefinedBoard.h"
#import "UIViewControllerStack.h"
#import "SNFPurchasing.h"

typedef NS_ENUM(NSInteger, SNFBoardListFilter){
	SNFBoardListFilterName,
	SNFBoardListFilterDate
};

typedef NS_ENUM(NSInteger, SNFBoardListSection){
	SNFBoardListSectionBoards,
	SNFBoardListSectionPredefinedBoards
};



@interface SNFBoardList : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, SNFBoardListCellDelegate, SNFBoardEditDelegate, UIViewControllerStackUpdating>{
	NSArray *_boards;
	NSArray *_predefinedBoards;
}

@property (weak) IBOutlet UITableView *boardsTable;
@property (weak) IBOutlet UISegmentedControl *filterControl;
@property (weak) IBOutlet UIButton *searchButton;
@property (weak) IBOutlet UIButton *purchaseButton;
@property (weak) IBOutlet UITextField *searchField;
@property SNFBoardListFilter filter;

@end
