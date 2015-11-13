#import <Foundation/Foundation.h>

#define SNFErrorDomain @"com.apptitude.smilesandfrowns"

typedef NS_ENUM(NSUInteger, SNFErrorCode){
	SNFErrorCodeRemoteError,
	SNFErrorCodeParseError,
	SNFErrorCodeDjangoDebugError,
	SNFErrorCodeInvalidModel,
	SNFErrorCodeFormInputError,
	SNFErrorCodeConcurrentSyncAttempt,
};



@interface SNFError : NSError

+ (SNFError * _Nonnull)errorWithCode:(SNFErrorCode)code andMessage:(NSString * _Nullable)message;

@end
