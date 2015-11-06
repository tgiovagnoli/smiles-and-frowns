#import <UIKit/UIKit.h>
#import "SNFPredefinedBoard.h"


@interface SNFPredefinedBoardCell : UITableViewCell

@property (weak) IBOutlet UILabel *titleLabel;
@property (nonatomic) SNFPredefinedBoard *predefinedBoard;


@end
