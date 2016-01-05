
#import "SNFUserService.h"
#import "SNFModel.h"
#import "SNFError.h"
#import "SNFUser.h"
#import "NSManagedObject+InfoDictionary.h"
#import "ATITwitterAuthHandler.h"
#import "ATIFacebookAuthHandler.h"
#import "SNFSyncService.h"

static NSURLSession * session = nil;

@interface SNFUserService ()
@property NSURLSession * session;
@end

@implementation SNFUserService

- (id) init {
	self = [super init];
	NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
	self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
	return self;
}

- (void) URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
	completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void) loginWithEmail:(NSString *) email andPassword:(NSString *) password withCompletion:(SNFUserServiceCallback) completion {
	NSURL * serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"login"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:serviceURL variables:@{@"email": email, @"password": password}];
	NSURLSession * session = self.session;
	NSURLSessionDataTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error, nil);
				return;
			}
			
			NSError * jsonError;
			NSObject * dataObject = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError) {
				completion(jsonError, nil);
				return;
			}
			
			SNFUser * userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)dataObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Could not create or update user."], nil);
				return;
			}
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:NO];
			completion(nil, userData);
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:YES];
		//});
	}];
	[task resume];
}

- (void) loginWithFacebookAuthToken:(NSString *) token withCompletion:(SNFUserServiceCallback)completion; {
	NSURL * serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"token_auth/facebook"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:serviceURL variables:@{@"access_token":token}];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error, nil);
				return;
			}
			
			NSError * jsonError;
			NSObject * dataObject = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError) {
				completion(jsonError, nil);
				return;
			}
			
			SNFUser * userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)dataObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Could not create or update user."], nil);
				return;
			}
			
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:NO];
			completion(nil, userData);
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:YES];
		//});
	}];
	[task resume];
}

- (void)loginWithTwitterAuthToken:(NSString *) token authSecret:(NSString *) secret withCompletion:(SNFUserServiceCallback)completion; {
	NSURL * serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"token_auth/twitter"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:serviceURL variables:@{@"access_token":token,@"access_token_secret":secret}];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error, nil);
				return;
			}
			
			NSError * jsonError;
			NSObject * dataObject = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError) {
				completion(jsonError, nil);
				return;
			}
			
			SNFUser * userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)dataObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Could not create or update user."], nil);
				return;
			}
			
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:NO];
			completion(nil, userData);
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:YES];
		//});
	}];
	[task resume];
}

- (void)logoutWithCompletion:(void(^)(NSError *error))completion{
	[[ATIFacebookAuthHandler instance] logout];
	[[ATITwitterAuthHandler instance] logout];
	
	NSURL * serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"logout"];
	NSURLSession * session = self.session;
	NSURLSessionDataTask * task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error);
				return;
			}
			
			NSError * jsonError;
			[self responseObjectFromData:data withError:&jsonError];
			if(jsonError) {
				completion(jsonError);
				return;
			}
			
			[[SNFModel sharedInstance] setLoggedInUser:nil updateLastLoggedIn:NO];
			completion(nil);
			[[SNFModel sharedInstance] setLoggedInUser:nil updateLastLoggedIn:YES];
		//});
	}];
	[task resume];
}

- (void)authedUserInfoWithCompletion:(SNFUserServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"user_info"];
	NSURLSession *session = self.session;
	NSURLSessionDataTask *task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error, nil);
				return;
			}
			
			NSError *jsonError;
			NSObject *dataObject = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError){
				completion(jsonError, nil);
				return;
			}
			
			SNFUser *userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)dataObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Not logged in."], nil);
				return;
			}
			
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:NO];
			completion(nil, userData);
			[[SNFModel sharedInstance] setLoggedInUser:userData updateLastLoggedIn:YES];
		//});
	}];
	[task resume];
}

- (void)inviteWithData:(NSDictionary *)data andCompletion:(SNFInviteCallback)completion{
	// validate data
	NSString *role = [data objectForKey:@"role"];
	NSString *boardUUID = [data objectForKey:@"board_uuid"];
	NSString *email = [data objectForKey:@"invitee_email"];
	NSString *firstName = [data objectForKey:@"invitee_firstname"];
	//NSString *lastName = [data objectForKey:@"invitee_lastname"];
	
	if(!email || ![email isValidEmail] || [email isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"email must be valid"]);
	}
	
	if(!boardUUID || [boardUUID isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a board"]);
	}
	
	// TODO: make sure board is valid and exists
	if(!firstName || [firstName isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a first name"]);
	}
	
	//if(!lastName || [lastName isEmpty]){
	//	return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a last name"]);
	//}
	
	if(!role || [role isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a role"]);
	}
	
	BOOL passRole = NO;
	
	if([role isEqualToString:SNFUserRoleParent] || [role isEqualToString:SNFUserRoleGuardian] || [role isEqualToString:SNFUserRoleChild]){
		passRole = YES;
	}
	
	if(!passRole){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"not a valid role"]);
	}
	
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"invite"];
	NSURLRequest *request = [NSURLRequest formURLEncodedPostRequestWithURL:serviceURL variables:data];
	NSURLSession *session = self.session;
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error){
				completion(error);
				return;
			}
			NSError *jsonError;
			[self responseObjectFromData:data withError:&jsonError];
			if(jsonError){
				completion(jsonError);
				return;
			}
			completion(nil);
		//});
	}];
	[task resume];
}

- (void) createAccountWithData:(NSDictionary *) data andCompletion:(SNFCreateAccountCompletion) completion; {
	if([data[@"email"] isEmpty]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Email required"],nil);
		return;
	}
	
	if(![data[@"email"] isValidEmail]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Incorrect email format"],nil);
		return;
	}
	
	if([data[@"firstname"] isEmpty]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"First Name required"],nil);
		return;
	}
	
	//if([data[@"lastname"] isEmpty]) {
	//	completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Last Name required"],nil);
	//	return;
	//}
	
	if([data[@"password"] isEmpty]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Password Required"],nil);
		return;
	}
	
	if(![data[@"password_confirm"] isEqualToString:data[@"password"]]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Passwords don't match"],nil);
		return;
	}
	
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"signup"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * dataObject = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError, nil);
				return;
			}
			
			SNFUser *userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)dataObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData){
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Not logged in."], nil);
				return;
			}
			
			completion(nil,userData);
		//});
	}];
	[task resume];
}

- (void)deleteInviteCode:(NSString *) inviteCode andCompletion:(SNFDeleteInviteCompletion)completion; {
	NSDictionary * data = nil;
	if(!inviteCode || inviteCode.isEmpty) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Invite code required"]);
	} else {
		data = @{@"code":inviteCode};
	}
	
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"invite_delete"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseData = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError);
				return;
			}
			
			if(![responseData isKindOfClass:[NSDictionary class]]) {
				return completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Expected dictionary"]);
			}
			
			completion(nil);
		//});
		
	}];
	
	[task resume];
}

- (void) acceptInviteCode:(NSString *) inviteCode andCompletion:(SNFAcceptInviteCompletion)completion; {
	NSDictionary * data = nil;
	if(!inviteCode || inviteCode.isEmpty) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Invite code required"],nil);
	}else{
		data = @{@"code":inviteCode};
	}
	
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"invite_accept"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseData = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError,nil);
				return;
			}
			
			if(![responseData isKindOfClass:[NSDictionary class]]) {
				return completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Expected dictionary"],nil);
			}
			
			completion(nil,(NSDictionary *)responseData);
		//});
		
	}];
	
	[task resume];
}

- (void) resetPasswordForEmail:(NSString *) email andCompletion:(void(^)(NSError *error))completion; {
	
	if(email.isEmpty) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Email required"]);
		return;
	}
	
	if(!email.isValidEmail) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Incorrect email format"]);
		return;
	}
	
	NSDictionary * data = @{@"email":email};
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"reset_password"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error);
				return;
			}
			
			NSError * jsonError = nil;
			[self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError);
				return;
			}
			
			completion(nil);
		//});
	}];
	
	[task resume];
}

- (void) invitesWithCompletion:(SNFInvitesCompletion) completion; {
	
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"invites"];
	NSURLRequest * request = [NSURLRequest requestWithURL:url];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error) {
				completion(error, nil, nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseObject = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError, nil, nil);
				return;
			}
			
			if([responseObject isKindOfClass:[NSDictionary class]]) {
				
				NSDictionary * invites = (NSDictionary *)responseObject;
				NSArray * received = invites[@"received_invites"];
				NSArray * sent = invites[@"sent_invites"];
				
				completion(nil,received,sent);
				
			} else {
				
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Error parsing invites"], nil, nil);
				
			}
		//});
		
	}];
	
	[task resume];
}

- (void) updateUserWithData:(NSDictionary *) data withCompletion:(SNFUserServiceCallback)completion; {
	
	if([data[@"first_name"] isEmpty]) {
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"First Name required"],nil);
	}
	
	if([data[@"last_name"] isEmpty]) {
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Last Name required"],nil);
	}
	
	if([data[@"email"] isEmpty]) {
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Email required"],nil);
	}
	
	if(![data[@"email"] isValidEmail]) {
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Incorrect email format"],nil);
	}
	
	if(![data[@"age"] isEmpty] && ([data[@"age"] integerValue] < 0 || [data[@"age"] integerValue] > 99)) {
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Age must be between 0 and 99"],nil);
	}
	
	if(![data[@"password"] isEmpty] && ![data[@"password_confirm"] isEmpty]) {
		if(![data[@"password"] isEqualToString:data[@"password_confirm"]]) {
			return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Passwords don't match"],nil);
		}
	}
	
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"update"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseObject = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError,nil);
				return;
			}
			
			SNFUser * userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)responseObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Not logged in."], nil);
				return;
			}
			
			[SNFModel sharedInstance].loggedInUser = userData;
			
			completion(nil,userData);
		//});
	}];
	
	[task resume];
}

- (void) updateUserProfileImageWithUsername:(NSString *) username image:(UIImage *) image withCompletion:(SNFProfileImageCompletion) completion; {
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"user_update_profile_image"];
	NSDictionary * variables = @{@"username":username};
	NSData * imageData = UIImageJPEGRepresentation(image,75);
	NSString * imageName = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".jpg"];
	NSURLRequest * request = [NSURLRequest fileUploadRequestWithURL:url data:imageData fileKey:@"image" fileName:imageName variables:variables];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			
			if(error) {
				completion(error,nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseObject = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError,nil);
				return;
			}
			
			SNFUser * userData = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:(NSDictionary *)responseObject withContext:[SNFModel sharedInstance].managedObjectContext];
			if(!userData) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Not logged in."], nil);
				return;
			}
			
			completion(nil,userData);
		//});
	}];
	
	[task resume];
}

- (void) uploadTempUserProfileImage:(UIImage *) image withCompletion:(SNFTempProfileImageCompletion) completion; {
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"upload_temp_profile_image"];
	NSData * imageData = UIImageJPEGRepresentation(image,75);
	NSString * imageName = [[[NSUUID UUID] UUIDString] stringByAppendingString:@".jpg"];
	NSURLRequest * request = [NSURLRequest fileUploadRequestWithURL:url data:imageData fileKey:@"image" fileName:imageName variables:nil];
	NSURLSessionDataTask * task = [self.session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			
			if(error) {
				completion(error,nil,nil);
				return;
			}
			
			NSError * jsonError = nil;
			NSObject * responseObject = [self responseObjectFromData:data withError:&jsonError];
			
			if(jsonError) {
				completion(jsonError,nil,nil);
				return;
			}
			
			if(![responseObject isKindOfClass:[NSDictionary class]]) {
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Expected a dictionary"],nil,nil);
				return;
			}
			
			NSDictionary * dictionary = (NSDictionary *)responseObject;
			completion(nil,dictionary[@"uuid"],dictionary[@"url"]);
			
		//});
	}];
	
	[task resume];
}

@end
