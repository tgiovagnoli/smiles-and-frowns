
#import "SNFADBannerView.h"
#import "IAPHelper.h"

NSString * const SNFADBannerViewPurchasedRemoveAds = @"SNFADBannerViewPurchasedRemoveAds";

@implementation SNFADBannerView

- (id) init {
	if([IAPHelper hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		return nil;
	}
	self = [super init];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdsPurchased:) name:SNFADBannerViewPurchasedRemoveAds object:nil];
	return self;
}

- (id) initWithAdType:(ADAdType)type {
	if([IAPHelper hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		return nil;
	}
	self = [super initWithAdType:type];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAdsPurchased:) name:SNFADBannerViewPurchasedRemoveAds object:nil];
	return self;
}

- (void) onAdsPurchased:(NSNotification *) note {
	if(self.delegate) {
		[self.delegate bannerView:self didFailToReceiveAdWithError:nil];
	}
}

@end
