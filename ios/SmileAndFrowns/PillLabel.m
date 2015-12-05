
#import "PillLabel.h"

@implementation PillLabel

- (void) drawTextInRect:(CGRect)rect {
	
	CGSize size = [self.text sizeWithAttributes:nil];
	size.width += 8;
	CGRect pill = CGRectMake( (self.bounds.size.width/2) - (size.width/2),0,size.width,self.bounds.size.height);
	UIBezierPath * path = [UIBezierPath bezierPathWithRoundedRect:pill cornerRadius:self.bounds.size.height/2];
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextSetFillColorWithColor(context,[[UIColor whiteColor] CGColor]);
	[path fill];
	
	[super drawTextInRect:rect];
}

@end
