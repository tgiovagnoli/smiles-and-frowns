#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^SNFPurchaseCallback)(NSError *error, NSObject *transactionInfo, BOOL cancelled);

@interface SNFPurchasing : NSObject

- (void)purchaseNewBoardWithCompletion:(SNFPurchaseCallback)completion;

@end
