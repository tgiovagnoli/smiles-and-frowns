
#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import "MBProgressHUD.h"
#import "SNFFormViewController.h"
#import "SNFBoard.h"
#import "SNFTaggedAlertAction.h"
#import "SNFSyncService.h"
#import "APDDjangoErrorViewer.h"
#import "SNFValuePicker.h"
#import "UIView+LayoutHelpers.h"
#import "SNFFormStyles.h"

extern NSString * const SNFAddUserRoleAddedChild;

@interface SNFAddUserRole : SNFFormViewController <UITextFieldDelegate,CNContactPickerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,SNFValuePickerDelegate>{
	NSString *_imageName;
	UIImage *_userSelectedImage;
	NSString *_selectedGender;
	
	SNFValuePicker *_genderPicker;
	SNFValuePicker *_agePicker;
}

@property SNFBoard * board;

@property (weak) IBOutlet UISegmentedControl * segment;
@property (weak) IBOutlet UITextField * firstname;
@property (weak) IBOutlet UITextField * lastname;
@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UIButton * genderOverlay;
@property (weak) IBOutlet UILabel * roleLabel;

@property (weak) IBOutlet UITextField * gender;
@property (weak) IBOutlet UITextField * age;
@property (weak) IBOutlet UIButton * ageOverlay;
@property (weak) IBOutlet UIImageView * image;
@property (weak) IBOutlet UIButton *addButton;
@property (weak) IBOutlet UIButton *addFromContactsButton;

@property (weak) IBOutlet NSLayoutConstraint *profileWidthContraint;
@property (weak) IBOutlet NSLayoutConstraint *firstNameLastNameLeftMargin;

@end
