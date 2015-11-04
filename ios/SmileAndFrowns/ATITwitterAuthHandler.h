
#import <Foundation/Foundation.h>
#import <TwitterKit/TwitterKit.h>
#import <Fabric/Fabric.h>

extern NSString * const ATITwitterAuthHandlerSessionChange;

@interface ATITwitterAuthHandler : NSObject

+ (ATITwitterAuthHandler *) instance;
- (void) login;
- (void) logout;

@end
