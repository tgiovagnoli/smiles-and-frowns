
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFUser.h"
#import "UIViewControllerStack.h"
#import "SNFUserService.h"
#import "SNFLogin.h"
#import "SNFFormViewController.h"
#import "SNFValuePicker.h"

#import "UIImage+Additions.h"
#import "APDDjangoErrorViewer.h"

@interface SNFUserProfile : SNFFormViewController <UITextFieldDelegate,UIViewControllerStackUpdating,UIImagePickerControllerDelegate,UINavigationControllerDelegate, SNFValuePickerDelegate>{
	SNFValuePicker *_genderPicker;
	SNFValuePicker *_agePicker;
}

@property (nonatomic) SNFUser * user;


@property (weak) IBOutlet UIImageView * profileImage;
@property (weak) IBOutlet UITextField * firstNameField;
@property (weak) IBOutlet UITextField * lastNameField;
@property (weak) IBOutlet UITextField * emailField;
@property (weak) IBOutlet UITextField * passwordField;
@property (weak) IBOutlet UITextField * passwordConfirmField;
@property (weak) IBOutlet UITextField * gender;
@property (weak) IBOutlet UIButton * genderOverlay;
@property (weak) IBOutlet UIButton * ageOverlay;
@property (weak) IBOutlet UITextField * age;
@property (weak) IBOutlet UIButton * updateUserButton;
@property (weak) IBOutlet UIButton * updatePasswordButton;
@end
