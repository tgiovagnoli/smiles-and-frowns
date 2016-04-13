
#import "SNFADBannerView.h"
#import "IAPHelper.h"
#import "SNFViewController.h"
#import "AppDelegate.h"

NSString * const SNFADBannerViewPurchasedRemoveAds = @"SNFADBannerViewPurchasedRemoveAds";

@implementation SNFADBannerView

- (id) initWithAdSize:(GADAdSize)adSize {
	self = [super initWithAdSize:adSize];
	self.adUnitID = @"ca-app-pub-2912900990256546/2289148516";
	self.rootViewController = [AppDelegate instance].window.rootViewController;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdsPurchased:) name:SNFADBannerViewPurchasedRemoveAds object:nil];
	return self;
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onAdsPurchased:(NSNotification *) note {
	if(self.delegate) {
		[self.delegate adView:self didFailToReceiveAdWithError:nil];
	}
}

@end
