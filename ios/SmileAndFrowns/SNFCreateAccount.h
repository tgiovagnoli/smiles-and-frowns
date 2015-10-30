
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SNFCreateAccount : UIViewController

@property UIViewController * nextViewController;

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UITextField * firstname;
@property (weak) IBOutlet UITextField * lastname;
@property (weak) IBOutlet UITextField * password;
@property (weak) IBOutlet UITextField * passwordConfirm;

@end
