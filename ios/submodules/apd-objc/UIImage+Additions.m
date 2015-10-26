#import "UIImage+Additions.h"

@implementation UIImage (Additions)

- (UIColor *)colorAtPosition:(CGPoint)position {
	CGRect sourceRect = CGRectMake(position.x, position.y, 1.0, 1.0);
	CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, sourceRect);
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	unsigned char *buffer = malloc(4);
	CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
	CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
	CGColorSpaceRelease(colorSpace);
	CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
	CGImageRelease(imageRef);
	CGContextRelease(context);
	
	CGFloat r = buffer[0] / 255.f;
	CGFloat g = buffer[1] / 255.f;
	CGFloat b = buffer[2] / 255.f;
	CGFloat a = buffer[3] / 255.f;
	
	free(buffer);
	
	return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

- (UIImage *) imageByCroppingImage:(UIImage *) image toSize:(CGSize) size {
	//not equivalent to image.size (which depends on the imageOrientation)!
	double refWidth = CGImageGetWidth(image.CGImage);
	double refHeight = CGImageGetHeight(image.CGImage);
	double x = (refWidth - size.width) / 2.0;
	double y = (refHeight - size.height) / 2.0;
	CGRect cropRect = CGRectMake(x, y, size.height, size.width);
	CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], cropRect);
	UIImage * cropped = [UIImage imageWithCGImage:imageRef scale:0.0 orientation:self.imageOrientation];
	CGImageRelease(imageRef);
	return cropped;
}

- (UIImage *)resizedImageWithSize:(CGSize)size andType:(UIImageResizingType)type{
	switch (type) {
		case UIImageResizingTypeStretch:
			return [self imageStretchedFromSize:size];
			break;
		case UIImageResizingTypeCrop:
			return [self imageCroppedFromSize:size];
			break;
		case UIImageResizingTypeFit:
			return [self imageCroppedFromSize:size];
			break;
	}
	return nil;
}

- (UIImage *)imageCroppedFromSize:(CGSize)size{
	CGFloat xPercent = size.width/self.size.width;
	CGFloat yPercent = size.height/self.size.height;
	CGFloat percentage = xPercent;
	if(yPercent > xPercent){
		percentage = yPercent;
	}
	CGSize finalSize = CGSizeMake(percentage * self.size.width, percentage * self.size.height);
	CGPoint offset = CGPointMake((size.width/2) - (finalSize.width/2), (size.height/2) - (finalSize.height/2));
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[self drawInRect:CGRectMake(offset.x, offset.y, finalSize.width, finalSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)imageStretchedFromSize:(CGSize)size{
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
	[self drawInRect:CGRectMake(0, 0, size.width, size.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

- (UIImage *)imageConstrainedWithinSize:(CGSize)size{
	CGFloat xPercent = size.width/self.size.width;
	CGFloat yPercent = size.height/self.size.height;
	CGFloat percentage = yPercent;
	if(yPercent > xPercent){
		percentage = xPercent;
	}
	CGSize finalSize = CGSizeMake(percentage * self.size.width, percentage * self.size.height);
	UIGraphicsBeginImageContextWithOptions(finalSize, NO, 0.0);
	[self drawInRect:CGRectMake(0.0, 0.0, finalSize.width, finalSize.height)];
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	return newImage;
}

@end
