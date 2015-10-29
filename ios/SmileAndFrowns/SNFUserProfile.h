#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFUser.h"
#import "UIViewControllerStack.h"
#import "SNFUserService.h"

@interface SNFUserProfile : UIViewController <UITextFieldDelegate>

@property (nonatomic) SNFUser *user;

@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UITextField *emailField;
@property (weak) IBOutlet UITextField *passwordField;
@property (weak) IBOutlet UITextField *passwordConfirmField;
@property IBOutlet UIView *blockingView;

- (void)loadAuthedUser;

@end
