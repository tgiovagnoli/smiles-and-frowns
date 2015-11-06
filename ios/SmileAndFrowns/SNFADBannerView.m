
#import "SNFADBannerView.h"
#import "IAPHelper.h"

@implementation SNFADBannerView

- (id) init {
	if([IAPHelper hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		return nil;
	}
	self = [super init];
	return self;
}

- (id) initWithAdType:(ADAdType)type {
	if([IAPHelper hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		return nil;
	}
	self = [super initWithAdType:type];
	return self;
}

@end
