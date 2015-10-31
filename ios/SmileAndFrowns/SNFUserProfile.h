
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFUser.h"
#import "UIViewControllerStack.h"
#import "SNFUserService.h"
#import "SNFLogin.h"

@interface SNFUserProfile : UIViewController <UITextFieldDelegate>

@property (nonatomic) SNFUser *user;

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UITextField *emailField;
@property (weak) IBOutlet UITextField *passwordField;
@property (weak) IBOutlet UITextField *passwordConfirmField;

- (void)loadAuthedUser;

@end
