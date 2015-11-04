
#import <UIKit/UIKit.h>

@interface UIViewController (Alerts)

- (void) displayOKAlertWithTitle:(NSString *) title message:(NSString *) msg completion:(void(^)(UIAlertAction *action)) completion;

@end
