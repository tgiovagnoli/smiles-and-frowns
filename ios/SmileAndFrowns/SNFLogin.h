
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFUser.h"

@class SNFLogin;

@interface SNFLogin : UIViewController

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@property IBOutlet UITextField * email;
@property IBOutlet UITextField * password;
@property UIViewController * nextViewController;

@end
