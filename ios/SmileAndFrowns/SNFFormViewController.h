
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SNFADBannerView.h"

@interface SNFFormViewController : UIViewController <ADBannerViewDelegate>

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;
@property CGFloat initialFormHeight;
@property SNFADBannerView * bannerView;

//on ipad this is adjusted for modals so the top title area doesn't have so much space.
@property IBOutlet NSLayoutConstraint * topMargin;

- (void) startBannerAd;
- (void) invalidateForScrolling;

@end
