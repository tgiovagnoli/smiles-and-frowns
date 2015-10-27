#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, SNFErrorCode){
	SNFErrorCodeRemoteError,
	SNFErrorCodeParseError,
	SNFErrorCodeDjangoDebugError,
};

@interface SNFError : NSError

+ (SNFError * _Nonnull)errorWithCode:(SNFErrorCode)code andMessage:(NSString * _Nullable)message;

@end
