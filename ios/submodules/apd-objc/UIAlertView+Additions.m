
#import "UIAlertView+Additions.h"

@implementation UIAlertView (Additions)

+ (UIAlertView *) alertWithMessage:(NSString *) message; {
	return [[UIAlertView alloc] initWithMessage:message];
}

+ (UIAlertView *) alertWithTitle:(NSString *) title message:(NSString *) message; {
	return [[UIAlertView alloc] initWithTitle:title message:message];
}

- (id) initWithMessage:(NSString *) message; {
	self = [super init];
	self.message = message;
	return self;
}

- (id) initWithTitle:(NSString *) title message:(NSString *) message; {
	self = [super init];
	self.message = message;
	self.title = title;
	return self;
}

@end
