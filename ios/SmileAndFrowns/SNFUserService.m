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
			completion(nil, userData);
			NSLog(@"%@", dataObject);
		});
	}];
	[task resume];
}


- (void)logoutWithCompletion:(void(^)(NSError *error))completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"logout"];
	NSURLSession *session = [NSURLSession sharedSession];
	NSURLSessionDataTask *task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
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

@end
