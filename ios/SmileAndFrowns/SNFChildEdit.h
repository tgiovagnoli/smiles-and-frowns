
#import <UIKit/UIKit.h>
#import "SNFFormViewController.h"
#import "SNFUser.h"
#import "UIView+LayoutHelpers.h"
#import "SNFValuePicker.h"
#import "MBProgressHUD.h"

typedef NS_ENUM(NSInteger, SNFChildEditSelectionType){
	SNFChildEditSelectionTypeGender,
	SNFChildEditSelectionTypeAge,
};

@class SNFChildEdit;

@protocol SNFChildEditDelegate <NSObject>
- (void)childEdit:(SNFChildEdit *)childEdit editedChild:(SNFUser *)child;
- (void)childEditCancelled:(SNFChildEdit *)childEdit;
@end

@interface SNFChildEdit : SNFFormViewController <UITextFieldDelegate, SNFValuePickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	SNFChildEditSelectionType _selectionType;
	UIImage *_userSelectedImage;
	SNFValuePicker *_genderPicker;
	SNFValuePicker *_agePicker;
}

@property (nonatomic) SNFUser *childUser;

@property (weak) IBOutlet UIImageView *profileImageView;
@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UITextField *genderField;
@property (weak) IBOutlet UITextField *ageField;
@property (weak) NSObject <SNFChildEditDelegate> *delegate;

@end
