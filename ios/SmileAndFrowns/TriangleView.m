
#import "TriangleView.h"

@interface TriangleView ()
@property UIColor * color;
@end

@implementation TriangleView

- (void) awakeFromNib {
	if(self.arrowDirection == 0) {
		self.arrowDirection = TriangleViewArrowDirectionDown;
	}
	self.color = self.backgroundColor;
	self.backgroundColor = [UIColor clearColor];
}

- (void) drawRect:(CGRect) rect {
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,self.color.CGColor);
	
	switch (self.arrowDirection) {
		case TriangleViewArrowDirectionUp:
			CGContextMoveToPoint(context,0,self.bounds.size.height);
			CGContextAddLineToPoint(context,self.bounds.size.width,self.bounds.size.height);
			CGContextAddLineToPoint(context,self.bounds.size.width/2,0);
			CGContextAddLineToPoint(context,0,self.bounds.size.height);
			break;
		case TriangleViewArrowDirectionRight:
			break;
		case TriangleViewArrowDirectionDown:
			CGContextMoveToPoint(context,0,0);
			CGContextAddLineToPoint(context,self.bounds.size.width,0);
			CGContextAddLineToPoint(context,self.bounds.size.width/2,self.bounds.size.height);
			CGContextAddLineToPoint(context,0,0);
			break;
		case TriangleViewArrowDirectionLeft:
			break;
		default:
			break;
	}
	
	CGContextFillPath(context);
}

@end
