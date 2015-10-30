
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SNFAcceptInvite : UIViewController
@property NSString * inviteCode;
@property (weak) IBOutlet UITextField * inviteCodeField;

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@end
