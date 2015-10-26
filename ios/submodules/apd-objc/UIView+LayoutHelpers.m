
#import "UIView+LayoutHelpers.h"

@implementation UIView (LayoutHelpers)

- (BOOL) visible {
	return !self.hidden;
}

- (void) setVisible:(BOOL) visible {
	self.hidden = !visible;
}

- (CGSize) size {
	return self.frame.size;
}

- (CGPoint) origin {
	return self.frame.origin;
}

- (void) setSize:(CGSize) size {
	CGRect f = self.frame;
	f.size = size;
	self.frame = f;
}

- (void) setOrigin:(CGPoint) origin {
	CGRect f = self.frame;
	f.origin = origin;
	self.frame = f;
}

- (CGFloat) top {
	return self.minY;
}

- (CGFloat) left {
	return self.minX;
}

- (CGFloat) right {
	return self.maxX;
}

- (CGFloat) bottom {
	return self.maxY;
}

- (void) setTop:(CGFloat) top {
	[self setY:top];
}

- (void) setLeft:(CGFloat) left {
	[self setX:left];
}

- (void) setRight:(CGFloat) right {
	CGRect f = self.frame;
	f.origin.x = right - self.width;
	self.frame = f;
}

- (void) setBottom:(CGFloat) bottom {
	CGRect f = self.frame;
	f.origin.y = bottom - self.height;
	self.frame = f;
}

- (CGFloat) minX {
	return CGRectGetMinX(self.frame);
}

- (CGFloat) minY {
	return CGRectGetMinY(self.frame);
}

- (CGFloat) maxX {
	return CGRectGetMaxX(self.frame);
}

- (CGFloat) maxY {
	return CGRectGetMaxY(self.frame);
}

- (CGFloat) x {
	return CGRectGetMinX(self.frame);
}

- (CGFloat) y {
	return CGRectGetMinY(self.frame);
}

- (CGFloat) width {
	return self.size.width;
	return CGRectGetWidth(self.frame);
}

- (CGFloat) height {
	return self.size.height;
	return CGRectGetHeight(self.frame);
}

- (void) offsetOrigin:(CGPoint) point; {
	CGRect f = self.frame;
	f.origin.x += point.x;
	f.origin.y += point.y;
	self.frame = f;
}

- (void) offsetSize:(CGSize) size {
	CGRect f = self.frame;
	f.size.width += size.width;
	f.size.height += size.height;
	self.frame = f;
}

- (void) offsetX:(CGFloat) x; {
	CGRect f = self.frame;
	f.origin.x += x;
	self.frame = f;
}

- (void) offsetY:(CGFloat) y; {
	CGRect f = self.frame;
	f.origin.y += y;
	self.frame = f;
}

- (void) offsetWidth:(CGFloat) width; {
	CGRect f = self.frame;
	f.size.width += width;
	self.frame = f;
}

- (void) offsetHeight:(CGFloat) height; {
	CGRect f = self.frame;
	f.size.height += height;
	self.frame = f;
}

- (void) setX:(CGFloat) newX; {
	CGRect f = self.frame;
	f.origin.x = newX;
	self.frame = f;
}

- (void) setY:(CGFloat) newY; {
	CGRect f = self.frame;
	f.origin.y = newY;
	self.frame = f;
}

- (void) setWidth:(CGFloat) newWidth; {
	CGRect f = self.frame;
	f.size.width = newWidth;
	self.frame = f;
}

- (void) setHeight:(CGFloat) newHeight; {
	CGRect f = self.frame;
	f.size.height = newHeight;
	self.frame = f;
}

- (void) setFrameX:(CGFloat) newX y:(CGFloat) newY width:(CGFloat) newWidth height:(CGFloat) newHeight; {
	CGRect f = self.frame;
	f.origin.x = newX;
	f.origin.y = newY;
	f.size.width = newWidth;
	f.size.height = newHeight;
	self.frame = f;
}

- (void) scaleView:(CGFloat) scale {
	CGRect frame = self.frame;
	CGFloat newWidth = CGRectGetWidth(frame) * scale;
	CGFloat newHeight = CGRectGetHeight(frame) * scale;
	CGFloat newX = CGRectGetMinX(frame) + ((CGRectGetWidth(frame) - newWidth)/2);
	CGFloat newY = CGRectGetMinY(frame) + ((CGRectGetHeight(frame) - newHeight)/2);
	CGRect newFrame = CGRectMake(newX,newY,newWidth,newHeight);
	self.frame = newFrame;
}

- (void) centerInRect:(CGRect) rect; {
	[self horizontalCenterInRect:rect];
	[self verticalCenterInRect:rect];
}

- (void) horizontalCenterInRect:(CGRect) rect; {
	self.x = floorf( CGRectGetMinX(rect) + ((CGRectGetWidth(rect) - self.width ) / 2) );
}

- (void) verticalCenterInRect:(CGRect) rect; {
	self.y = floorf( CGRectGetMinY(rect) +  ((CGRectGetHeight(rect) - self.height) / 2) );
}

- (void) matchFrameSizeOfView:(UIView *)view{
	self.width = view.width;
	self.height = view.height;
}

@end
