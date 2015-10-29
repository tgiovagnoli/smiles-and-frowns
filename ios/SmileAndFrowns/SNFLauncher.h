
#import <UIKit/UIKit.h>

@interface SNFLauncher : UIViewController

@property (weak) IBOutlet UIButton * showOnStartup;

+ (BOOL) showAtLaunch;

@end
