
#import "SNFUserService.h"
#import "SNFModel.h"
#import "SNFError.h"
#import "SNFUser.h"

@implementation SNFUserService

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password withCompletion:(SNFUserServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"login"];
	NSURLRequest *request = [NSURLRequest formURLEncodedPostRequestWithURL:serviceURL variables:@{@"email": email, @"password": password}];
	
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if(error){
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
			if(!userData){
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Could not create or update user."], nil);
				return;
			}
			[SNFModel sharedInstance].loggedInUser = userData;
			completion(nil, userData);
		});
	}];
	[task resume];
}

- (void)logoutWithCompletion:(void(^)(NSError *error))completion{
	NSURL * serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"logout"];
	NSURLSession * session = [NSURLSession sharedSession];
	NSURLSessionDataTask * task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
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
			
			[SNFModel sharedInstance].loggedInUser = nil;
			completion(nil);
		});
	}];
	[task resume];
}

- (void)authedUserInfoWithCompletion:(SNFUserServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"user_info"];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if(error){
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
			if(!userData){
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"Not logged in."], nil);
				return;
			}
			[SNFModel sharedInstance].loggedInUser = userData;
			completion(nil, userData);
		});
	}];
	[task resume];
}

- (void)inviteWithData:(NSDictionary *)data andCompletion:(SNFInviteCallback)completion{
	// validate data
	NSString *role = [data objectForKey:@"role"];
	NSString *boardUUID = [data objectForKey:@"board_uuid"];
	NSString *email = [data objectForKey:@"invitee_email"];
	NSString *firstName = [data objectForKey:@"invitee_firstname"];
	NSString *lastName = [data objectForKey:@"invitee_lastname"];
	
	if(!email || ![email isValidEmail] || email.isEmpty){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"email must be valid"]);
	}
	if(!boardUUID || [boardUUID isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a board"]);
	}
	// TODO: make sure board is valid and exists
	if(!firstName || [firstName isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a first name"]);
	}
	if(!lastName || [lastName isEmpty]){
		return completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"must include a last name"]);
	}
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
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_sync(dispatch_get_main_queue(), ^{
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
		});
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
	
	if([data[@"lastname"] isEmpty]) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Last Name required"],nil);
		return;
	}
	
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
	NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_async(dispatch_get_main_queue(), ^{
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
		});
	}];
	[task resume];
}

- (void) acceptInviteCode:(NSString *) inviteCode andCompletion:(SNFAcceptInviteCompletion)completion; {
	
	if(!inviteCode) {
		completion([SNFError errorWithCode:SNFErrorCodeFormInputError andMessage:@"Invite code required"]);
	}
	
	NSDictionary * data = @{@"code":inviteCode};
	NSURL * url = [[SNFModel sharedInstance].config apiURLForPath:@"invite_accept"];
	NSURLRequest * request = [NSURLRequest formURLEncodedPostRequestWithURL:url variables:data];
	NSURLSessionDataTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		
		dispatch_async(dispatch_get_main_queue(), ^{
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
		});
		
	}];
	
	[task resume];
}

@end
