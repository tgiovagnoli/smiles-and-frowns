
#import "UIFont+Additions.h"

@implementation UIFont (Additions)

- (UIFont *) fontWithOffsetSize:(CGFloat) size {
	return [UIFont fontWithName:self.fontName size:self.pointSize+size];
}

@end
