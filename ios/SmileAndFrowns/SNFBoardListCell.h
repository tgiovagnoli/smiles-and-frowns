#import <UIKit/UIKit.h>
#import "SNFBoard.h"

@interface SNFBoardListCell : UITableViewCell

@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) SNFBoard *board;

@end
