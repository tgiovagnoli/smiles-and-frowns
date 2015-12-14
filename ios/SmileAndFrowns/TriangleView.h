
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,TriangleViewArrowDirection) {
	TriangleViewArrowDirectionUp = 1,
	TriangleViewArrowDirectionRight,
	TriangleViewArrowDirectionDown,
	TriangleViewArrowDirectionLeft,
};

IB_DESIGNABLE
@interface TriangleView : UIView

@property IBInspectable TriangleViewArrowDirection arrowDirection;

@end
