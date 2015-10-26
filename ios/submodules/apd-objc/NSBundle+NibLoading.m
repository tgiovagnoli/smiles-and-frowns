
#import "NSBundle+NibLoading.h"
#import "UIDevice+Hardware.h"

@implementation NSBundle (NibLoading)

- (id) loadViewNibNamed:(NSString *) nibName; {
	return [self loadViewNibNamed:nibName owner:nil options:nil];
}

- (id) loadViewNibNamed:(NSString *) nibName owner:(id) owner options:(NSDictionary *) options; {
	return [[[NSBundle mainBundle] loadNibNamed:nibName owner:owner options:options] objectAtIndex:0];
}

- (id) loadViewNibNamedWithDeviceIdiom:(NSString *) nibName; {
	return [self loadViewNibNamedWithDeviceIdiom:nibName owner:nil options:nil];
}

- (id) loadViewNibNamedWithDeviceIdiom:(NSString *) nibName owner:(id) owner options:(NSDictionary *) options; {
	NSString * nib = nil;
	if([[UIDevice currentDevice] isIphone]) {
		nib = [nibName stringByAppendingString:@"~iPhone"];
	} else {
		nib = [nibName stringByAppendingString:@"~iPad"];
	}
	return [[[NSBundle mainBundle] loadNibNamed:nib owner:owner options:options] objectAtIndex:0];
}

@end
