
#import <UIKit/UIKit.h>

@interface UIView (LayoutHelpers)

@property CGFloat left; //same as x.
@property CGFloat top;  //same as y.
@property CGFloat right; //sets x to right-width.
@property CGFloat bottom; //sets y to bottom-height.

@property CGFloat x;
@property CGFloat y;
@property CGFloat width;
@property CGFloat height;

@property CGSize size;
@property CGPoint origin;

@property BOOL visible;

- (CGFloat) minY; //top edge of view.
- (CGFloat) minX; //left edge of view.
- (CGFloat) maxY; //top+height of view.
- (CGFloat) maxX; //left+width of view.
- (void) offsetX:(CGFloat) x;
- (void) offsetY:(CGFloat) y;
- (void) offsetWidth:(CGFloat) width;
- (void) offsetHeight:(CGFloat) height;
- (void) offsetSize:(CGSize) size;
- (void) offsetOrigin:(CGPoint) point;
- (void) setFrameX:(CGFloat) newX y:(CGFloat) newY width:(CGFloat) newWidth height:(CGFloat) newHeight;

//resizes and and keeps the view at the same center point.
- (void) scaleView:(CGFloat) scale;

- (void) centerInRect:(CGRect) rect;
- (void) horizontalCenterInRect:(CGRect) rect;
- (void) verticalCenterInRect:(CGRect) rect;
- (void) matchFrameSizeOfView:(UIView *)view;

@end
