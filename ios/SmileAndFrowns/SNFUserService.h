
#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFUser.h"
#import "SNFUserRole.h"
#import "NSURLRequest+Additions.h"
#import "NSManagedObject+InfoDictionary.h"
#import "NSURLRequest+Additions.h"
#import "NSString+Additions.h"

typedef void(^SNFUserServiceCallback)(NSError *error, SNFUser *user);
typedef void(^SNFInviteCallback)(NSError *error);
typedef void(^SNFCreateAccountCompletion)(NSError * error,SNFUser * user);
typedef void(^SNFAcceptInviteCompletion)(NSError * error);

@interface SNFUserService : SNFService

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(SNFUserServiceCallback)completion;
- (void)logoutWithCompletion:(void(^)(NSError *error))completion;
- (void)authedUserInfoWithCompletion:(SNFUserServiceCallback)completion;
- (void)inviteWithData:(NSDictionary *)data andCompletion:(SNFInviteCallback)completion;

- (void) createAccountWithData:(NSDictionary *) data andCompletion:(SNFCreateAccountCompletion)completion;
- (void) acceptInviteCode:(NSString *) inviteCode andCompletion:(SNFAcceptInviteCompletion)completion;
- (void) resetPasswordForEmail:(NSString *) email andCompletion:(void(^)(NSError *error))completion;

@end
