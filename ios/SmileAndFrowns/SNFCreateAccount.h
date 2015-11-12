
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"

@interface SNFCreateAccount : SNFFormViewController <UITextFieldDelegate>

@property UIViewController * nextViewController;

@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UITextField * firstname;
@property (weak) IBOutlet UITextField * lastname;
@property (weak) IBOutlet UITextField * password;
@property (weak) IBOutlet UITextField * passwordConfirm;

@end
