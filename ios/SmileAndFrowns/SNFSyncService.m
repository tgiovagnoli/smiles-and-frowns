#import "SNFSyncService.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFReward.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFUserRole.h"

@implementation SNFSyncService

- (void)syncWithCompletion:(SNFSyncServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"sync/push"];
	
	NSDictionary *postData = [self createPostInfoDictionary];
	NSError *jsonError;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&jsonError];
	if(jsonError){
		completion(jsonError, nil);
	}
	
#if DEBUG
	NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSLog(@">> POSTING:\n\n%@\n\n-----------------------\n", jsonString);
#endif

	NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serviceURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:jsonData];
	NSURLSession *session = [NSURLSession sharedSession];
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		dispatch_sync(dispatch_get_main_queue(), ^{
			if(error){
				completion(error, nil);
				return;
			}
			NSError *jsonError;
			NSObject *infoDict = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError){
				completion(jsonError, nil);
				return;
			}
			if([infoDict isMemberOfClass:[NSDictionary class]] || [infoDict isKindOfClass:[NSDictionary class]]){
				[self updateLocalDataWithResults:(NSDictionary *)infoDict andCallCompletion:completion];
			}else{
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"expected dictionary"], nil);
			}
		});
	}];
	[task resume];
}

- (NSDictionary *)createPostInfoDictionary{
	NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
	
	NSDate *lastSyncDate = [SNFModel sharedInstance].userSettings.lastSyncDate;
	if(lastSyncDate){
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		NSString *dateString = [formatter stringFromDate:lastSyncDate];
		[postData setObject:dateString forKey:@"sync_date"];
	}else{
		[postData setObject:[NSNull null] forKey:@"sync_date"];
	}
	
	NSDate *fromDate = [SNFModel sharedInstance].userSettings.lastSyncDate;
	if(!fromDate){
		fromDate = [NSDate dateWithTimeIntervalSince1970:0];
	}
	
	[postData setObject:[self collectionForEntityName:@"SNFBoard" sinceSyncDate:fromDate] forKey:@"boards"];
	[postData setObject:[self collectionForUserRolesSinceSyncDate:fromDate] forKey:@"user_roles"];
	[postData setObject:[self collectionForEntityName:@"SNFBehavior" sinceSyncDate:fromDate] forKey:@"behaviors"];
	[postData setObject:[self collectionForEntityName:@"SNFReward" sinceSyncDate:fromDate] forKey:@"rewards"];
	[postData setObject:[self collectionForEntityName:@"SNFSmile" sinceSyncDate:fromDate] forKey:@"smiles"];
	[postData setObject:[self collectionForEntityName:@"SNFFrown" sinceSyncDate:fromDate] forKey:@"frowns"];
	return postData;
}

- (NSArray *)collectionForUserRolesSinceSyncDate:(NSDate *)syncDate{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFUserRole"];
	request.predicate = [NSPredicate predicateWithFormat:@"updated_date > %@", syncDate];
	NSArray *results = [context executeFetchRequest:request error:&error];
	NSMutableArray *infoCollection = [[NSMutableArray alloc] init];
	for(SNFUserRole *obj in results){
		NSDictionary *info = [obj infoDictionaryWithChildrenAsUIDs];
		NSDictionary *userInfo = @{@"user": [obj.user infoDictionary]};
		NSMutableDictionary *final = [[NSMutableDictionary alloc] init];
		[final addEntriesFromDictionary:info];
		[final addEntriesFromDictionary:userInfo];
		[infoCollection addObject:final];
	}
	return infoCollection;
}

- (NSArray *)collectionForEntityName:(NSString *)name sinceSyncDate:(NSDate *)syncDate{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:name];
	request.predicate = [NSPredicate predicateWithFormat:@"updated_date > %@", syncDate];
	NSArray *results = [context executeFetchRequest:request error:&error];
	NSMutableArray *infoCollection = [[NSMutableArray alloc] init];
	for(NSManagedObject *obj in results){
		[infoCollection addObject:[obj infoDictionaryWithChildrenAsUIDs]];
	}
	return infoCollection;
}


- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	
	NSMutableArray *updates = [[NSMutableArray alloc] init];
	// update the user's local sync date
	NSString *syncString = [results objectForKey:@"sync_date"];
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	NSDate *latestSyncDate = [formatter dateFromString:syncString];
	if(latestSyncDate){
		[SNFModel sharedInstance].userSettings.lastSyncDate = latestSyncDate;
	}
	
	NSMutableDictionary *changeLog = [[NSMutableDictionary alloc] init];
	// update boards
	NSArray *boardUpdates = [results valueForKey:@"boards"];
	if(boardUpdates){
		NSMutableArray *boardChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *boardUpdate in boardUpdates){
			SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardUpdate withContext:context];
			[boardChanges addObject:board];
		}
		[changeLog setObject:boardChanges forKey:@"boards"];
	}
	// update user roles
	NSArray *userRoleUpdates = [results valueForKey:@"user_roles"];
	if(userRoleUpdates){
		NSMutableArray *userRoleChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *userRoleUpdate in userRoleUpdates){
			SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:userRoleUpdate withContext:context];
			[userRoleChanges addObject:userRole];
		}
		[changeLog setObject:userRoleChanges forKey:@"user_roles"];
	}
	
	// update behaviors
	NSArray *behaviorUpdates = [results valueForKey:@"behaviors"];
	if(behaviorUpdates){
		NSMutableArray *behaviorChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *behaviorUpdate in behaviorUpdates){
			SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorUpdate withContext:context];
			[behaviorChanges addObject:behavior];
		}
		[changeLog setObject:behaviorChanges forKey:@"behaviors"];
	}
	// update rewards
	NSArray *rewardsUpdates = [results valueForKey:@"rewards"];
	if(rewardsUpdates){
		NSMutableArray *rewardChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *rewardsUpdate in rewardsUpdates){
			SNFReward *reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardsUpdate withContext:context];
			[rewardChanges addObject:reward];
		}
		[changeLog setObject:rewardChanges forKey:@"rewards"];
	}
	// update smiles
	NSArray *smilesUpdates = [results valueForKey:@"smiles"];
	if(smilesUpdates){
		NSMutableArray *smilesChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *smilesUpdate in smilesUpdates){
			SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smilesUpdate withContext:context];
			[smilesChanges addObject:smile];
		}
		[changeLog setObject:smilesChanges forKey:@"smiles"];
	}
	// update frowns
	NSArray *frownsUpdates = [results valueForKey:@"frowns"];
	if(frownsUpdates){
		NSMutableArray *frownsChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *frownsUpdate in frownsUpdates){
			SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownsUpdate withContext:context];
			[frownsChanges addObject:frown];
		}
		[changeLog setObject:frownsChanges forKey:@"frowns"];
	}
	[updates addObject:changeLog];

#if DEBUG
	NSLog(@">> RECIEVING:\n\n%@\n\n-----------------------\n", updates);
#endif
	
	completion(nil, updates);
}








@end
