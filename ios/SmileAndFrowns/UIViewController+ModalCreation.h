
#import <UIKit/UIKit.h>
#import "UIView+LayoutHelpers.h"

@interface UIViewController (ModalCreation)

- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize;

@end
