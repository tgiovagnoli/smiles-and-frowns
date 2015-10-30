
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface SNFPasswordReset : UIViewController

@property IBOutlet UIView * formView;
@property (weak) IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;

@property (weak) IBOutlet UITextField * email;

@end
