
#import <UIKit/UIKit.h>
#import "SNFUserRole.h"
#import "SNFUser.h"
#import "SNFSwipeCell.h"
#import "UIView+LayoutHelpers.h"

@class SNFBoardDetailAdultCell;

@protocol SNFBoardDetailAdultCellDelegate <NSObject>
- (void)adultCell:(SNFBoardDetailAdultCell *)cell wantsToRemoveUserRole:(SNFUserRole *)userRole;
@end

@interface SNFBoardDetailAdultCell : SNFSwipeCell

@property (nonatomic) SNFUser *user;
@property (nonatomic) SNFUserRole *userRole;

@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UIImageView *profileImageView;
@property (weak) NSObject <SNFBoardDetailAdultCellDelegate> *delegate;

@end
