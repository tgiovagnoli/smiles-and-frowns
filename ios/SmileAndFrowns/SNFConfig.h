#import <Foundation/Foundation.h>

@interface SNFConfig : NSObject

@property (readonly) NSURL *serverURL;
@property (readonly) NSURL *apiURL;

- (NSURL *)apiURLForPath:(NSString *)path;

@end
