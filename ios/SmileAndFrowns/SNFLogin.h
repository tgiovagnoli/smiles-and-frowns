
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFUser.h"
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "UIViewController+ModalCreation.h"
#import "SNFFormStyles.h"

extern NSString * const SNFLoginLoggedIn;

@class SNFLogin;

@interface SNFLogin : SNFFormViewController <UITextFieldDelegate>

@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UITextField * password;
@property (weak) IBOutlet UIButton * loginButton;
@property UIViewController * nextViewController;

@end
