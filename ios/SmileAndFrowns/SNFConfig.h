
#import <Foundation/Foundation.h>

@interface SNFConfig : NSObject

@property (readonly) NSURL *serverURL;
@property (readonly) NSURL *apiURL;

- (NSURL *) apiURLForPath:(NSString *)path;
- (NSString *) twitterKey;
- (NSString *) twitterSecret;
- (NSString *) profileImageAuthUsername;
- (NSString *) profileImageAuthPassword;

@end
