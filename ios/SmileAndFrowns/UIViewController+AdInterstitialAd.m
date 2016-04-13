
#import "UIViewController+AdInterstitialAd.h"

static UIWindow * adWindow;
static UIView * adContainer;
static GADInterstitial * _interstitial;

@implementation UIViewController (AdInterstitialAd)

- (void) startInterstitialAd {
	if([[IAPHelper defaultHelper] hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		return;
	}
	
	if(!_interstitial) {
		_interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2912900990256546/3765881719"];
		_interstitial.delegate = self;
		[_interstitial loadRequest:[GADRequest request]];
	}
	
	if(!adWindow) {
		adWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	}
	
	if(!adContainer) {
		adContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		adWindow.rootViewController = [[UIViewController alloc] init];
		adWindow.rootViewController.view = adContainer;
	}
	
	if([[SNFModel sharedInstance] shouldShowInterstitial] && [_interstitial isReady]) {
		[self showInterstitial];
	}
}

- (void) showInterstitial {
	[[SNFModel sharedInstance] resetInterstitial];
	adContainer.alpha = 0;
	[adWindow makeKeyAndVisible];
	[_interstitial presentFromRootViewController:adWindow.rootViewController];
	[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
		adContainer.alpha = 1;
	} completion:^(BOOL finished) {
	}];
}

- (void) interstitial:(GADInterstitial *)ad didFailToReceiveAdWithError:(GADRequestError *)error {
	NSLog(@"error: %@",error);
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
	if(!adWindow.isKeyWindow) {
		return;
	}
	NSLog(@"interstitial finished");
	[[AppDelegate instance].window makeKeyAndVisible];
	//[adWindow.rootViewController.view removeFromSuperview];
	
	_interstitial = [[GADInterstitial alloc] initWithAdUnitID:@"ca-app-pub-2912900990256546/3765881719"];
	_interstitial.delegate = self;
	[_interstitial loadRequest:[GADRequest request]];
}

@end
