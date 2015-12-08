#import <UIKit/UIKit.h>
#import "SNFBehavior.h"
#import "SNFSwipeCell.h"

@class SNFBoardEditBehaviorCell;

@protocol SNFBoardEditBehaviorCellDelegate <NSObject>
- (void)behaviorCell:(SNFBoardEditBehaviorCell *)cell wantsToDeleteBehavior:(SNFBehavior *)behavior;
@end

@interface SNFBoardEditBehaviorCell : SNFSwipeCell

@property (weak) IBOutlet UILabel *titleLabel;
@property (nonatomic) SNFBehavior *behavior;
@property (weak) NSObject <SNFBoardEditBehaviorCellDelegate> *delegate;
@property (weak) IBOutlet UIButton * deleteButton;

- (IBAction)onDelete:(UIButton *)sender;

@end
