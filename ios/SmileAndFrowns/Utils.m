
#import "Utils.h"

@implementation Utils

+ (BOOL) CGFloatHasDecimals:(float) f {
	return (f-(int)f != 0);
}

@end
