
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SNFCreateAccount : UIViewController <UIPickerViewDataSource,UIPickerViewDelegate>

@property UIViewController * nextViewController;

@property IBOutlet UIView * pickerviewContainer;
@property (weak) IBOutlet UIPickerView * pickerView;

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UITextField * firstname;
@property (weak) IBOutlet UITextField * lastname;
@property (weak) IBOutlet UITextField * password;
@property (weak) IBOutlet UITextField * passwordConfirm;
@property (weak) IBOutlet UITextField * gender;
@property (weak) IBOutlet UIButton * genderOverlay;
@property (weak) IBOutlet UITextField * age;

@end
