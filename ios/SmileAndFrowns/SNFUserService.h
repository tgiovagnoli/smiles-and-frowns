#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFUser.h"
#import "NSURLRequest+Additions.h"
#import "NSManagedObject+InfoDictionary.h"

typedef void(^SNFUserServiceCallback)(NSError *error, SNFUser *user);

@interface SNFUserService : SNFService

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(SNFUserServiceCallback)completion;
- (void)logoutWithCompletion:(void(^)(NSError *error))completion;
- (void)authedUserInfoWithCompletion:(SNFUserServiceCallback)completion;


@end
