#import "UIImageView+ProfileStyle.h"

@implementation UIImageView (ProfileStyle)

- (void)setImage:(UIImage *)image asProfileWithBorderColor:(UIColor *)color andBorderThickness:(CGFloat)thickness{
	if(!color){
		color = [UIColor blackColor];
	}
	
	CGFloat size = self.frame.size.width;
	if(self.frame.size.width > self.frame.size.height){
		size = self.frame.size.height;
	}
	UIImageView *tempView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0, size, size)];
	tempView.contentMode = UIViewContentModeScaleAspectFit;
	tempView.clipsToBounds = YES;
	
	tempView.image = image;
	// Get the Layer of any view
	[tempView.layer setMasksToBounds:YES];
	[tempView.layer setCornerRadius:tempView.frame.size.width/2.0];
	[tempView.layer setBorderWidth:thickness];
	[tempView.layer setBorderColor:[color CGColor]];
	UIGraphicsBeginImageContextWithOptions(tempView.bounds.size, NO, 0.0);
	[tempView.layer renderInContext:UIGraphicsGetCurrentContext()];
	self.image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
}

@end
