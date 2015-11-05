
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface SNFFormViewController : UIViewController <ADBannerViewDelegate>

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;
@property CGFloat initialFormHeight;
@property ADBannerView * bannerView;

- (CGFloat) scrollViewBottomConstraint:(NSNotification *) notification;
- (void) starBannerAd;

@end
