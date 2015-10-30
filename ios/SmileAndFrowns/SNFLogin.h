
#import <UIKit/UIKit.h>
#import "SNFUser.h"

@class SNFLogin;

@protocol SNFLoginDelegate <NSObject>
- (void) login:(SNFLogin *) login didLoginWithUser:(SNFUser *) user;
- (void) loginCancelled:(SNFLogin *) login;
@end

@interface SNFLogin : UIViewController

@property IBOutlet UITextField * email;
@property IBOutlet UITextField * password;
@property UIViewController * nextViewController;
@property (weak) NSObject <SNFLoginDelegate> *delegate;

@end
