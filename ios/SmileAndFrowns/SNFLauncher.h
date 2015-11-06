
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIViewController+ModalCreation.h"
#import "UIView+LayoutHelpers.h"

@interface SNFLauncher : UIViewController <ADBannerViewDelegate>

@property (weak) IBOutlet UISwitch * showOnStartup;
@property (weak) IBOutlet UIButton * loginButton;
@property (weak) IBOutlet UILabel * showOnStartupLabel;
@property IBOutlet NSLayoutConstraint * showOnStartupLabelBottom;
@property (weak) IBOutlet UIButton * createAccountButton;

+ (BOOL) showAtLaunch;

@end
