#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import "SNFUserRole.h"
#import "SNFBoard.h"
#import "NSString+Additions.h"
#import "UIView+LayoutHelpers.h"

typedef NS_ENUM(NSInteger, SNFUserRoleAdd){
	SNFUserRoleAddChild,
	SNFUserRoleAddParent,
	SNFUserRoleAddGuardian
};

typedef void(^SNFAddUserRoleCallback)(NSError *error, SNFUserRole *userRole);

@interface SNFAddUserRole : UIViewController <UITextFieldDelegate, CNContactPickerDelegate, UIPickerViewDataSource, UIPickerViewDelegate>{
	SNFAddUserRoleCallback _completion;
	NSArray *_pickerValues;
	BOOL _hasLaidOut;
}

@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UISegmentedControl *roleControl;
@property (weak) IBOutlet UITextField *emailField;
@property (weak) IBOutlet UITextField *genderField;
@property (weak) IBOutlet UITextField *ageField;
@property (weak) IBOutlet UIImageView *profileImageView;

@property IBOutlet UIView *genderPickerContainer;
@property (weak) IBOutlet UIPickerView *genderPicker;

@property (readonly) SNFBoard *board;

- (void)setBoard:(SNFBoard *)board andCompletion:(SNFAddUserRoleCallback)completion;

- (IBAction)onAddRole:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onAddFromContacts:(UIButton *)sender;
- (IBAction)closeGenderPicker:(UIButton *)sender;
- (void)addChildRole;
- (void)addParentRole;
- (void)addGuardianRole;

@end
