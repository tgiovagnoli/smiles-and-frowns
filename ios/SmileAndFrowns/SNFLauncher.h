
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIViewController+ModalCreation.h"
#import "UIView+LayoutHelpers.h"
#import "SNFFormStyles.h"
#import "UIViewController+AdInterstitialAd.h"
@import GoogleMobileAds;

@interface SNFLauncher : UIViewController <GADBannerViewDelegate>

@property (weak) IBOutlet UISwitch * showOnStartup;
@property (weak) IBOutlet UIButton * loginButton;
@property (weak) IBOutlet UIButton * acceptInviteButton;
@property (weak) IBOutlet UIButton * createAccountButton;
@property (weak) IBOutlet NSLayoutConstraint * bottom;
@property IBOutletCollection(UIButton) NSArray *buttons;

+ (BOOL) showAtLaunch;

@end
