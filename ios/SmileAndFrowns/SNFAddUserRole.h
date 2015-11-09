
#import <UIKit/UIKit.h>
#import <ContactsUI/ContactsUI.h>
#import "MBProgressHUD.h"
#import "SNFFormViewController.h"
#import "SNFBoard.h"
#import "SNFTaggedAlertAction.h"
#import "SNFSyncService.h"

extern NSString * const SNFAddUserRoleAddedChild;

@interface SNFAddUserRole : SNFFormViewController <UITextFieldDelegate,UIPickerViewDataSource,UIPickerViewDelegate,CNContactPickerDelegate>

@property SNFBoard * board;

@property (weak) IBOutlet UISegmentedControl * segment;
@property (weak) IBOutlet UITextField * firstname;
@property (weak) IBOutlet UITextField * lastname;
@property (weak) IBOutlet UITextField * email;
@property (weak) IBOutlet UIButton * genderOverlay;
@property (weak) IBOutlet UITextField * gender;
@property (weak) IBOutlet UITextField * age;
@property (weak) IBOutlet UIImageView * image;

@property (weak) IBOutlet UIPickerView * pickerview;
@property IBOutlet UIView * pickerviewContainer;

@end
