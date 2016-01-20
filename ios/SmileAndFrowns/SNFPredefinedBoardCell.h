
#import <UIKit/UIKit.h>
#import "SNFPredefinedBoard.h"

@class SNFPredefinedBoardCell;

@protocol SNFPredefinedBoardCellDelegate <NSObject>
- (void) boardCellWantsToPurchase:(SNFPredefinedBoardCell *) cell;
@end

@interface SNFPredefinedBoardCell : UITableViewCell
@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UIButton * purchase;
@property (weak) NSObject <SNFPredefinedBoardCellDelegate> * delegate;
@property (nonatomic) SNFPredefinedBoard *predefinedBoard;
@end
