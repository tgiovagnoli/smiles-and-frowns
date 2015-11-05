
#import <UIKit/UIKit.h>

@interface SNFFormViewController : UIViewController

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;
@property CGFloat initialFormHeight;

- (CGFloat) scrollViewBottomConstraint:(NSNotification *) notification;

@end
