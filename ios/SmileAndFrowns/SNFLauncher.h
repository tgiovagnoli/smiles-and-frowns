
#import <UIKit/UIKit.h>

@interface SNFLauncher : UIViewController

@property (weak) IBOutlet UISwitch * showOnStartup;
@property (weak) IBOutlet UIButton * loginButton;
@property (weak) IBOutlet UIButton * createAccountButton;

+ (BOOL) showAtLaunch;

@end
