
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SNFADBannerView.h"

@interface SNFFormViewController : UIViewController <ADBannerViewDelegate>

@property IBOutlet UIView * formView;
@property IBOutlet UIScrollView * scrollView;
@property IBOutlet NSLayoutConstraint * scrollViewBottom;
@property CGFloat initialFormHeight;
@property SNFADBannerView * bannerView;

- (void) startBannerAd;

@end
