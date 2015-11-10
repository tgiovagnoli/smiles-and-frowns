#import <UIKit/UIKit.h>
#import "SNFUserRole.h"
#import "SNFUser.h"

@class SNFBoardDetailChildCell;

@protocol SNFBoardDetailChildCellDelegate <NSObject>
- (void)childCellWantsToAddSmile:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToAddFrown:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToSpend:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
- (void)childCellWantsToOpenReport:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole;
@end

@interface SNFBoardDetailChildCell : UITableViewCell

@property (nonatomic) SNFUserRole *userRole;

@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UILabel *smilesCountLabel;
@property (weak) IBOutlet UILabel *frownsCountLabel;
@property (weak) IBOutlet UILabel *spendLabel;
@property (weak) IBOutlet UIButton *smileButton;
@property (weak) IBOutlet UIButton *frownButton;
@property (weak) IBOutlet UIButton *spendButton;
@property (weak) IBOutlet UIImageView *profileImage;

@property (weak) NSObject <SNFBoardDetailChildCellDelegate> *delegate;

- (IBAction)onSmile:(UIButton *)sender;
- (IBAction)onFrown:(UIButton *)sender;
- (IBAction)onSpend:(UIButton *)sender;
- (void)onReport:(UITapGestureRecognizer *)sender;

@end
