
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
typedef void(^SNFAcceptInviteCompletion)(NSError * error, NSDictionary * data);
typedef void(^SNFDeleteInviteCompletion)(NSError * error);
typedef void(^SNFInvitesCompletion)(NSError * error, NSArray * receivedInvites, NSArray * sentInvites);
typedef void(^SNFProfileImageCompletion)(NSError * error, SNFUser * user);

@interface SNFUserService : SNFService

- (void)createAccountWithData:(NSDictionary *) data andCompletion:(SNFCreateAccountCompletion)completion;

- (void)authedUserInfoWithCompletion:(SNFUserServiceCallback)completion;
- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(SNFUserServiceCallback)completion;
- (void)loginWithFacebookAuthToken:(NSString *) token withCompletion:(SNFUserServiceCallback)completion;
- (void)loginWithTwitterAuthToken:(NSString *) token authSecret:(NSString *) secret withCompletion:(SNFUserServiceCallback)completion;
- (void)logoutWithCompletion:(void(^)(NSError *error))completion;
- (void)resetPasswordForEmail:(NSString *) email andCompletion:(void(^)(NSError *error))completion;
- (void)updateUserWithData:(NSDictionary *) data withCompletion:(SNFUserServiceCallback)completion;
- (void)updateUserProfileWithUsername:(NSString *) username image:(UIImage *) image withCompletion:(SNFProfileImageCompletion) completion;

- (void)invitesWithCompletion:(SNFInvitesCompletion) completion;
- (void)inviteWithData:(NSDictionary *)data andCompletion:(SNFInviteCallback)completion;
- (void)acceptInviteCode:(NSString *) inviteCode andCompletion:(SNFAcceptInviteCompletion)completion;
- (void)deleteInviteCode:(NSString *) inviteCode andCompletion:(SNFDeleteInviteCompletion)completion;

@end
