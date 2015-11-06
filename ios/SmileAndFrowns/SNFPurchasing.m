#import "SNFPurchasing.h"


@implementation SNFPurchasing

- (void)purchaseNewBoardWithCompletion:(SNFPurchaseCallback)completion{
	completion(nil, @{@"id": [[NSUUID UUID] UUIDString]}, NO);
}

@end
