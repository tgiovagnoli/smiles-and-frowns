
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFUser.h"
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"

@class SNFLogin;

@interface SNFLogin : SNFFormViewController <UITextFieldDelegate>

@property IBOutlet UITextField * email;
@property IBOutlet UITextField * password;
@property UIViewController * nextViewController;

@end
