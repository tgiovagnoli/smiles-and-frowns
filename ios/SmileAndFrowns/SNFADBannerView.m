
#import "SNFADBannerView.h"
#import "IAPHelper.h"
#import "SNFViewController.h"
#import "AppDelegate.h"

NSString * const SNFADBannerViewPurchasedRemoveAds = @"SNFADBannerViewPurchasedRemoveAds";

@interface SNFADBannerView ()
@property NSTimer * reload;
@end

@implementation SNFADBannerView

- (id) initWithAdSize:(GADAdSize)adSize {
	self = [super initWithAdSize:adSize];
	self.adUnitID = @"ca-app-pub-2912900990256546/2289148516";
	self.rootViewController = [AppDelegate instance].window.rootViewController;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdsPurchased:) name:SNFADBannerViewPurchasedRemoveAds object:nil];
	self.reload = [NSTimer scheduledTimerWithTimeInterval:15 target:self selector:@selector(startBannerAd) userInfo:nil repeats:TRUE];
	return self;
}

- (void) startBannerAd {
	if(self.delegate) {
		[self.delegate adView:self didFailToReceiveAdWithError:nil];
	}
	self.rootViewController = [AppDelegate instance].window.rootViewController;
	[self loadRequest:[GADRequest request]];
}

- (void) dealloc {
	[self.reload invalidate];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onAdsPurchased:(NSNotification *) note {
	if(self.delegate) {
		[self.delegate adView:self didFailToReceiveAdWithError:nil];
	}
}

@end
