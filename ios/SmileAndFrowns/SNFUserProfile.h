
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFUser.h"
#import "UIViewControllerStack.h"
#import "SNFUserService.h"
#import "SNFLogin.h"
#import "SNFFormViewController.h"

@interface SNFUserProfile : SNFFormViewController <UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate,UIViewControllerStackUpdating>

@property (nonatomic) SNFUser * user;

@property IBOutlet UIView * pickerviewContainer;
@property IBOutlet UIPickerView * pickerView;

@property (weak) IBOutlet UITextField * firstNameField;
@property (weak) IBOutlet UITextField * lastNameField;
@property (weak) IBOutlet UITextField * emailField;
@property (weak) IBOutlet UITextField * passwordField;
@property (weak) IBOutlet UITextField * passwordConfirmField;
@property (weak) IBOutlet UITextField * gender;
@property (weak) IBOutlet UIButton * genderOverlay;
@property (weak) IBOutlet UITextField * age;

@end
