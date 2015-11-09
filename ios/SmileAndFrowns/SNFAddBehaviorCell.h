
#import <UIKit/UIKit.h>
#import "SNFPredefinedBehavior.h"
#import "NSString+Additions.h"

@interface SNFAddBehaviorCell : UITableViewCell <UITextFieldDelegate>

@property (weak) IBOutlet UITextField * behaviorTitleField;
@property (weak) IBOutlet UIButton * editButton;
@property (nonatomic) SNFPredefinedBehavior * behavior;

@end