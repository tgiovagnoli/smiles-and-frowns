#import "SNFError.h"


@implementation SNFError

+ (SNFError * _Nonnull)errorWithCode:(SNFErrorCode)code andMessage:(NSString * _Nullable)message{
	return [SNFError errorWithDomain:SNFErrorDomain code:code userInfo:@{NSLocalizedDescriptionKey:message}];
}

@end
