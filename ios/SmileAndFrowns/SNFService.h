#import <Foundation/Foundation.h>
#import "SNFError.h"

@interface SNFService : NSObject

- (NSObject *)responseObjectFromData:(NSData *)data withError:(__autoreleasing NSError **)error;

@end
