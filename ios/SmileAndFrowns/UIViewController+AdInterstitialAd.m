
#import "UIViewController+AdInterstitialAd.h"

static UIView * adContainer;
static ADInterstitialAd * _interstitial;
static BOOL showOnLoad = FALSE;

@implementation UIViewController (AdInterstitialAd)

- (void) startInterstitialAd {
	if(!adContainer) {
		adContainer = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
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
	[NSTimer scheduledTimerWithTimeInterval:.5 block:^{
		UIViewController * rootvc = [AppDelegate instance].window.rootViewController;
		UIView * root = rootvc.view;
		BOOL isIpad = UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
		
		if(!isIpad && rootvc.presentedViewController) {
			[[SNFModel sharedInstance] resetInterstitial];
			root = rootvc.presentedViewController.view;
			adContainer.alpha = 0;
			[root addSubview:adContainer];
			[_interstitial presentInView:adContainer];
			[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				adContainer.alpha = 1;
			} completion:^(BOOL finished) {
				
			}];
		}
		
		if(isIpad) {
			if(rootvc.presentedViewController) {
				[rootvc dismissViewControllerAnimated:FALSE completion:nil];
			}
			[[SNFModel sharedInstance] resetInterstitial];
			adContainer.alpha = 0;
			[root addSubview:adContainer];
			[_interstitial presentInView:adContainer];
			[UIView animateWithDuration:.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
				adContainer.alpha = 1;
			} completion:^(BOOL finished) {
				
			}];
		}
		
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
	[adContainer removeFromSuperview];
}

@end
