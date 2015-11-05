
#import <UIKit/UIKit.h>

@interface SNFFormViewController : UIViewController

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;
@property CGFloat minFormViewHeight;

- (CGFloat) scrollViewBottomConstraint:(NSNotification *) notification;

@end
