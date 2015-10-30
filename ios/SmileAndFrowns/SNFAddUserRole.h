#import <UIKit/UIKit.h>
#import "SNFUserRole.h"
#import "SNFBoard.h"
#import "NSString+Additions.h"

typedef NS_ENUM(NSInteger, SNFUserRoleAdd){
	SNFUserRoleAddChild,
	SNFUserRoleAddParent,
	SNFUserRoleAddGuardian
};

typedef void(^SNFAddUserRoleCallback)(NSError *error, SNFUserRole *userRole);

@interface SNFAddUserRole : UIViewController <UITextFieldDelegate>{
	SNFAddUserRoleCallback _completion;
}

@property (weak) IBOutlet UITextField *firstNameField;
@property (weak) IBOutlet UITextField *lastNameField;
@property (weak) IBOutlet UISegmentedControl *roleControl;
@property (weak) IBOutlet UITextField *emailField;
@property (weak) IBOutlet UITextField *genderField;
@property (weak) IBOutlet UITextField *ageField;
@property (weak) IBOutlet UIImageView *profileImageView;
@property (readonly) SNFBoard *board;

- (void)setBoard:(SNFBoard *)board andCompletion:(SNFAddUserRoleCallback)completion;

- (IBAction)onAddRole:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onAddFromContacts:(UIButton *)sender;
- (void)addChildRole;
- (void)addParentRole;
- (void)addGuardianRole;

@end
