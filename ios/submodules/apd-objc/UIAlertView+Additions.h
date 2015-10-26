
#import <UIKit/UIKit.h>

@interface UIAlertView (Additions)

+ (UIAlertView *) alertWithMessage:(NSString *) message;
+ (UIAlertView *) alertWithTitle:(NSString *) title message:(NSString *) message;

- (id) initWithMessage:(NSString *) message;
- (id) initWithTitle:(NSString *) title message:(NSString *) message;

@end
