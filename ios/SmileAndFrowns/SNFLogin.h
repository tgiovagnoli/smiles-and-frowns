
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFUser.h"
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "UIViewController+ModalCreation.h"

extern NSString * const SNFLoginLoggedIn;

@class SNFLogin;

@interface SNFLogin : SNFFormViewController <UITextFieldDelegate>

@property IBOutlet UITextField * email;
@property IBOutlet UITextField * password;
@property UIViewController * nextViewController;

@end
