#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UIImageResizingType){
	UIImageResizingTypeCrop,
	UIImageResizingTypeFit,
	UIImageResizingTypeStretch
};

@interface UIImage (Additions)

- (UIColor *)colorAtPosition:(CGPoint)position;
- (UIImage *) imageByCroppingImage:(UIImage *) image toSize:(CGSize) size;
- (UIImage *)resizedImageWithSize:(CGSize)size andType:(UIImageResizingType)type;
- (UIImage *)imageStretchedFromSize:(CGSize)size;
- (UIImage *)imageCroppedFromSize:(CGSize)size;
- (UIImage *)imageConstrainedWithinSize:(CGSize)size;

@end
