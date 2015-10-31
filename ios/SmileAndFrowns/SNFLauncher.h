
#import <UIKit/UIKit.h>

@interface SNFLauncher : UIViewController

@property (weak) IBOutlet UISwitch * showOnStartup;

+ (BOOL) showAtLaunch;

@end
