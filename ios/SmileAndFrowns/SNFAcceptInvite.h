
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFInvite.h"

extern NSString * const SNFInviteAccepted;

@interface SNFAcceptInvite : UIViewController

@property NSString * inviteCode;
@property SNFInvite * invite;

@property (weak) IBOutlet UILabel * joinLabel;
@property (weak) IBOutlet UITextField * inviteCodeField;

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@end
