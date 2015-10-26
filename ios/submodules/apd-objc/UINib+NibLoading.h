
#import <UIKit/UIKit.h>

@interface UINib (NibLoading)

+ (UINib *) nibWithNibNameForDevice:(NSString *)name bundle:(NSBundle *)bundleOrNil;

@end
