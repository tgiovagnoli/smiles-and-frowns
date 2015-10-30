#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "NSString+Additions.h"

@class SNFBoardEdit;

@protocol  SNFBoardEditDelegate <NSObject>
- (void)boardEditor:(SNFBoardEdit *)be finishedWithBoard:(SNFBoard *)board;
@end

@interface SNFBoardEdit : UIViewController <UITextFieldDelegate>

@property (weak) IBOutlet UITextField *boardTitleField;
@property (weak) IBOutlet UITableView *behaviorsTable;
@property (weak) IBOutlet UICollectionView *rewardsCollectionView;

@property (weak) IBOutlet UIButton *addBehaviorButton;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) IBOutlet UIButton *useBoardButton;

@property (nonatomic) IBOutlet SNFBoard *board;
@property (weak) NSObject <SNFBoardEditDelegate> *delegate;


- (IBAction)onUpdateBoard:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;

@end
