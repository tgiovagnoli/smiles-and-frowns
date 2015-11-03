
#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFUser.h"
#import "SNFFormViewController.h"

@class SNFLogin;

@interface SNFLogin : SNFFormViewController

@property IBOutlet UITextField * email;
@property IBOutlet UITextField * password;
@property UIViewController * nextViewController;

@end
