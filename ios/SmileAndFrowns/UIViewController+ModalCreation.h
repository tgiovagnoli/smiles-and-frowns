
#import <UIKit/UIKit.h>
#import "UIView+LayoutHelpers.h"

@interface UIViewController (ModalCreation)

- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize;
- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize arrowDirections:(UIPopoverArrowDirection) arrowDirections;

@end
