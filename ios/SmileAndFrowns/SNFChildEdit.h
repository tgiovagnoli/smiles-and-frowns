#import <UIKit/UIKit.h>
#import "SNFFormViewController.h"
#import "SNFUser.h"
#import "UIView+LayoutHelpers.h"

typedef NS_ENUM(NSInteger, SNFChildEditSelectionType){
	SNFChildEditSelectionTypeGender,
	SNFChildEditSelectionTypeAge,
};

@class SNFChildEdit;

@protocol SNFChildEditDelegate <NSObject>
- (void)childEdit:(SNFChildEdit *)childEdit editedChild:(SNFUser *)child;
- (void)childEditCancelled:(SNFChildEdit *)childEdit;
@end

@interface SNFChildEdit : SNFFormViewController <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate>{
	NSArray *_genderValues;
	NSArray *_ageValues;
	SNFChildEditSelectionType _selectionType;
	UIImage *_userSelectedImage;
}

@property (nonatomic) SNFUser *childUser;

@property (weak) IBOutlet UIImageView *profileImageView;
@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UITextField *genderField;
@property (weak) IBOutlet UITextField *ageField;
@property IBOutlet UIView *selectionContainer;
@property (weak) IBOutlet UIPickerView *pickerView;
@property (weak) IBOutlet UIButton *selectionDoneButton;
@property (weak) NSObject <SNFChildEditDelegate> *delegate;

@end
