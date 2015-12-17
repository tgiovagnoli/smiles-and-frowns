#import <UIKit/UIKit.h>
#import "SNFUserRole.h"
#import "SNFUser.h"
#import "SNFSwipeCell.h"
#import "UIImageView+ProfileStyle.h"

@class SNFBoardDetailChildCell;

@protocol SNFBoardDetailChildCellDelegate <NSObject>
- (void)childCellWantsToAddSmile:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToAddFrown:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToSpend:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToOpenReport:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToDelete:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToEdit:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToReset:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
@end

@interface SNFBoardDetailChildCell : SNFSwipeCell

@property (nonatomic) BOOL isLastCell;

@property (nonatomic) SNFUserRole * userRole;

@property (weak) IBOutlet UIButton * editButton;

@property (weak) IBOutlet UIView * containerView;

@property (weak) IBOutlet UIView * profileContainer;
@property (weak) IBOutlet UIImageView * profileImage;
@property (weak) IBOutlet UILabel * nameLabel;

@property (weak) IBOutlet UIView * frownContainer;
@property IBOutlet NSLayoutConstraint * frownLeft;
@property (weak) IBOutlet UIImageView * frownImage;
@property (weak) IBOutlet UIButton * frownButton;
@property (weak) IBOutlet UILabel * frownsCountLabel;

@property (weak) IBOutlet UIView * smileContainer;
@property IBOutlet NSLayoutConstraint * smileLeft;
@property (weak) IBOutlet UIImageView * smileImage;
@property (weak) IBOutlet UILabel * spendLabel;
@property (weak) IBOutlet UIButton * spendButton;
@property (weak) IBOutlet UIButton * smileButton;
@property (weak) IBOutlet UILabel * smilesCountLabel;

@property (weak) IBOutlet UIView * spendContainer;
@property (weak) IBOutlet UIImageView * spendImage;

@property (weak) NSObject <SNFBoardDetailChildCellDelegate> *delegate;

@property IBOutlet NSLayoutConstraint * spendCenterY;
@property IBOutlet NSLayoutConstraint * bottomSpacing;

- (IBAction)onSmile:(UIButton *)sender;
- (IBAction)onFrown:(UIButton *)sender;
- (IBAction)onSpend:(UIButton *)sender;
- (void)onReport:(UITapGestureRecognizer *)sender;
- (IBAction)onDelete:(UIButton *)sender;
- (IBAction)onEdit:(UIButton *)sender;

@end
