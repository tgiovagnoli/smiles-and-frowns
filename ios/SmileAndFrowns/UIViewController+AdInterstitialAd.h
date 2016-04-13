
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "SNFModel.h"
#import "AppDelegate.h"
#import "NSTimer+Blocks.h"
#import "IAPHelper.h"
@import GoogleMobileAds;

@interface UIViewController (AdInterstitialAd) <GADInterstitialDelegate>
- (void) startInterstitialAd;
@end
