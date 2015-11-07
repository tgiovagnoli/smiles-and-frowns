#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "SNFSwipeCell.h"

@class SNFBoardListCell;

@protocol SNFBoardListCellDelegate <NSObject>
- (void)boardListCell:(SNFBoardListCell *)cell wantsToEditBoard:(SNFBoard *)board;
- (void)boardListCell:(SNFBoardListCell *)cell wantsToResetBoard:(SNFBoard *)board;
@end

@interface SNFBoardListCell : SNFSwipeCell

@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UILabel *dateLabel;
@property IBOutlet UIButton * editButton;
@property (weak, nonatomic) SNFBoard *board;
@property (weak) NSObject <SNFBoardListCellDelegate> *delegate;

@end
