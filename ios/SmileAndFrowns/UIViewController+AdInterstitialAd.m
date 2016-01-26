
#import "UIViewController+AdInterstitialAd.h"

static UIWindow * adWindow;
static UIView * adContainer;
static ADInterstitialAd * _interstitial;
static BOOL showOnLoad = FALSE;

@implementation UIViewController (AdInterstitialAd)

- (void) startInterstitialAd {
	if(!adWindow) {
		adWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	}
	
	if(!adContainer) {
		adContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
		adWindow.rootViewController = [[UIViewController alloc] init];
		adWindow.rootViewController.view = adContainer;
	}
	
	if(!_interstitial) {
		_interstitial = [[ADInterstitialAd alloc] init];
		_interstitial.delegate = self;
		showOnLoad = FALSE;
	}
	
	if([[SNFModel sharedInstance] shouldShowInterstitial]) {
		if(_interstitial.loaded) {
			[self showInterstitial];
		} else {
			showOnLoad = TRUE;
			_interstitial = [[ADInterstitialAd alloc] init];
			_interstitial.delegate = self;
		}
	}
}

- (void) showInterstitial {
	NSLog(@"show interstitial");
	[NSTimer scheduledTimerWithTimeInterval:.25 block:^{
		[[SNFModel sharedInstance] resetInterstitial];
		adContainer.alpha = 0;
		[adWindow makeKeyAndVisible];
		[_interstitial presentInView:adContainer];
		[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
			adContainer.alpha = 1;
		} completion:^(BOOL finished) {
			
		}];
	} repeats:FALSE];
}

- (void) interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd {
	NSLog(@"interstitial did load");
	if(showOnLoad) {
		[self showInterstitial];
	}
}

- (void) interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd {
	NSLog(@"interstitial unload");
	[adContainer removeFromSuperview];
	_interstitial.delegate = nil;
	_interstitial = nil;
}

- (void) interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd {
	NSLog(@"interstitial will load");
}

- (void) interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error {
	NSLog(@"interstitial fail with error %@",error);
	[adContainer removeFromSuperview];
	_interstitial.delegate = nil;
	_interstitial = nil;
}

- (void) interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd {
	NSLog(@"interstitial finished");
	[[AppDelegate instance].window makeKeyAndVisible];
}

@end
