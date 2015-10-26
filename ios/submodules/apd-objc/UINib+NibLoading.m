
#import "UINib+NibLoading.h"
#import "UIDevice+Hardware.h"

@implementation UINib (NibLoading)

+ (UINib *) nibWithNibNameForDevice:(NSString *) name bundle:(NSBundle *) bundleOrNil; {
	NSString * nibName = nil;
	if([[UIDevice currentDevice] isIphone]) {
		nibName = [name stringByAppendingString:@"~iPhone"];
	} else {
		nibName = [name stringByAppendingString:@"~iPad"];
	}
	return [UINib nibWithNibName:nibName bundle:bundleOrNil];
}

@end
