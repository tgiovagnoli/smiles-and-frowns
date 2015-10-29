#import <UIKit/UIKit.h>
#import "SNFUserRole.h"
#import "SNFUser.h"

@interface SNFBoardDetailAdultCell : UITableViewCell

@property (nonatomic) SNFUserRole *userRole;

@property (weak) IBOutlet UILabel *nameLabel;
@property (weak) IBOutlet UILabel *noteLabel;
@property (weak) IBOutlet UIImageView *profileImageView;

@end
