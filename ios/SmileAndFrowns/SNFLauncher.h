
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIViewController+ModalCreation.h"
#import "UIView+LayoutHelpers.h"
#import "SNFFormStyles.h"

@interface SNFLauncher : UIViewController <ADBannerViewDelegate>

@property (weak) IBOutlet UISwitch * showOnStartup;
@property (weak) IBOutlet UIButton * loginButton;
@property (weak) IBOutlet UIButton * acceptInviteButton;
@property (weak) IBOutlet UILabel * showOnStartupLabel;
@property IBOutlet NSLayoutConstraint * showOnStartupLabelBottom;
@property (weak) IBOutlet UIButton * createAccountButton;
@property IBOutletCollection(UIButton) NSArray *buttons;

+ (BOOL) showAtLaunch;

@end
