
#import "SNFSyncService.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFReward.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFUserRole.h"
#import "SNFPredefinedBoard.h"
#import "SNFPredefinedBehavior.h"
#import "SNFPredefinedBehaviorGroup.h"
#import "SNFSpendableSmile.h"

NSString * const SNFSyncServiceCompleted = @"SNFSyncServiceCompleted";
NSString * const SNFSyncServiceError = @"SNFSyncServiceError";

static SNFSyncService * _instance;

@interface SNFSyncService ()
@property NSURLSession * session;
@end

@implementation SNFSyncService

+ (SNFSyncService *) instance {
	if(!_instance) {
		_instance = [[SNFSyncService alloc] init];
	}
	return _instance;
}

- (id) init {
	self = [super init];
	_syncTimer = [NSTimer scheduledTimerWithTimeInterval:(60.0 * 10.0) target:self selector:@selector(attemptSync:) userInfo:nil repeats:YES];
	NSURLSessionConfiguration * config = [NSURLSessionConfiguration defaultSessionConfiguration];
	self.session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
	//[self attemptSync:nil];
	return self;
}

- (void) URLSession:(NSURLSession *)session didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition, NSURLCredential * _Nullable))completionHandler {
	completionHandler(NSURLSessionAuthChallengeUseCredential,[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust]);
}

- (void)attemptSync:(NSTimer *)syncTimer{
	if([SNFModel sharedInstance].loggedInUser || _syncing){
		return;
	}
	[self syncWithCompletion:^(NSError *error, NSObject *boardData) {
		if(error){
			NSLog(@"\n !!!! error syncing !!!! :\n\n %@", error.localizedDescription);
		}
	}];
}

- (void) syncWithCompletion:(SNFSyncServiceCallback) completion {
	if(_syncing) {
		completion([SNFError errorWithCode:SNFErrorCodeConcurrentSyncAttempt andMessage:@"Tried to sync while already syncing."], nil);
		return;
	}
	
	[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
	_syncing = YES;
	NSError *saveError;
	
	if(![SNFModel sharedInstance].userSettings.lastSyncDate){
		NSLog(@"not synced clean local database");
		[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
		[self purgeLocalData];
	}
	
	[[SNFModel sharedInstance].managedObjectContext save:&saveError]; // save the context in its current state before syncing so that any newer dates are committed.
	
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"sync"];
	
	NSDictionary *postData = [self createPostInfoDictionary];
	NSError *jsonError;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:postData options:0 error:&jsonError];
	
	if(jsonError) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		completion(jsonError, nil);
	}
	
	NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:serviceURL];
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
	[request setHTTPBody:jsonData];
	NSURLSession * session = self.session;
	
	NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			_syncing = NO;
			
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFSyncServiceCompleted object:nil];
			
			if(error){
				NSLog(@"error: %@",error);
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
				[[NSNotificationCenter defaultCenter] postNotificationName:SNFSyncServiceError object:error];
				return completion(error, nil);
			}
			
			NSError *jsonError;
			NSObject *infoDict = [self responseObjectFromData:data withError:&jsonError];
			if(jsonError){
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
				[[NSNotificationCenter defaultCenter] postNotificationName:SNFSyncServiceError object:jsonError];
				return completion(jsonError, nil);
			}
			
			if([infoDict isMemberOfClass:[NSDictionary class]] || [infoDict isKindOfClass:[NSDictionary class]]){
				[self updateLocalDataWithResults:(NSDictionary *)infoDict andCallCompletion:completion];
			}else{
				SNFError *error = [SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"expected dictionary"];
				[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
				[[NSNotificationCenter defaultCenter] postNotificationName:SNFSyncServiceError object:error];
				return completion(error, nil);
			}
		//});
	}];
	[task resume];
}

- (NSDictionary *) createPostInfoDictionary {
	NSMutableDictionary * postData = [[NSMutableDictionary alloc] init];
	
	NSDate * lastSyncDate = [SNFModel sharedInstance].userSettings.lastSyncDate;
	if(lastSyncDate) {
		lastSyncDate = [lastSyncDate dateByAddingTimeInterval:-5*60];
		NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		NSString *dateString = [formatter stringFromDate:lastSyncDate];
		[postData setObject:dateString forKey:@"sync_date"];
	}
	
	NSDate * fromDate = [SNFModel sharedInstance].userSettings.lastSyncDate;
	if(!fromDate) {
		fromDate = [NSDate date];
		//fromDate = [NSDate dateWithTimeIntervalSince1970:0];
	}
	//else {
	//	fromDate = [fromDate dateByAddingTimeInterval:-5*60];
	//}
	
	[postData setObject:[self collectionForEntityName:@"SNFBoard" sinceSyncDate:fromDate] forKey:@"boards"];
	[postData setObject:[self collectionForUserRolesSinceSyncDate:fromDate] forKey:@"user_roles"];
	[postData setObject:[self collectionForEntityName:@"SNFBehavior" sinceSyncDate:fromDate] forKey:@"behaviors"];
	[postData setObject:[self collectionForEntityName:@"SNFReward" sinceSyncDate:fromDate] forKey:@"rewards"];
	[postData setObject:[self collectionForEntityName:@"SNFSmile" sinceSyncDate:fromDate] forKey:@"smiles"];
	[postData setObject:[self collectionForEntityName:@"SNFFrown" sinceSyncDate:fromDate] forKey:@"frowns"];
	[postData setObject:[self collectionForEntityName:@"SNFSpendableSmile" sinceSyncDate:fromDate] forKey:@"spendable_smiles"];
	
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
		NSDictionary * info = [obj infoDictionaryWithChildrenAsUIDs];
		NSDictionary * userInfo = @{};
		if(obj.user) {
			userInfo = @{@"user": [obj.user infoDictionary]};
		}
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


- (void)purgeLocalData{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	for(SNFBehavior *behavior in [SNFBehavior allObjectsWithContext:context]){
		[context deleteObject:behavior];
	}
	for(SNFReward *reward in [SNFReward allObjectsWithContext:context]){
		[context deleteObject:reward];
	}
	for(SNFSmile *smile in [SNFSmile allObjectsWithContext:context]){
		[context deleteObject:smile];
	}
	for(SNFFrown *frown in [SNFFrown allObjectsWithContext:context]){
		[context deleteObject:frown];
	}
	for(SNFUserRole *userRole in [SNFUserRole allObjectsWithContext:context]){
		[context deleteObject:userRole];
	}
	for(SNFBoard *board in [SNFBoard allObjectsWithContext:context]){
		[context deleteObject:board];
	}
	for(SNFSpendableSmile * spendsmile in [SNFSpendableSmile allObjectsWithContext:context]) {
		[context deleteObject:spendsmile];
	}
}


- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	
	NSMutableArray *updates = [[NSMutableArray alloc] init];
	BOOL updated = NO;
	
	// update the user's local sync date
	NSString *syncString = [results objectForKey:@"sync_date"];
	if(syncString) {
		NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
		[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
		[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
		NSDate *latestSyncDate = [formatter dateFromString:syncString];
		if(latestSyncDate){
			[SNFModel sharedInstance].userSettings.lastSyncDate = latestSyncDate;
		}
	}
	
	NSMutableDictionary * changeLog = [[NSMutableDictionary alloc] init];
	
	[SNFDateManager lock]; // lock the date manager before saving the context so that all updates that are made keep the server date
	
	// update boards
	NSArray * boardUpdates = [results valueForKey:@"boards"];
	if(boardUpdates) {
		NSMutableArray *boardChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *boardUpdate in boardUpdates){
			SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardUpdate withContext:context];
			[boardChanges addObject:board];
			updated = YES;
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
			updated = YES;
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
			updated = YES;
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
			updated = YES;
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
			updated = YES;
		}
		[changeLog setObject:smilesChanges forKey:@"smiles"];
	}
	
	
	// update spendable smiles
	NSArray * spendableSmilesUpdates = [results valueForKey:@"spendable_smiles"];
	if(spendableSmilesUpdates) {
		NSMutableArray * smilesChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *smilesUpdate in spendableSmilesUpdates){
			SNFSmile *smile = (SNFSmile *)[SNFSpendableSmile editOrCreatefromInfoDictionary:smilesUpdate withContext:context];
			[smilesChanges addObject:smile];
			updated = YES;
		}
		[changeLog setObject:smilesChanges forKey:@"spendable_smiles"];
	}
	
	// update frowns
	NSArray *frownsUpdates = [results valueForKey:@"frowns"];
	if(frownsUpdates){
		NSMutableArray *frownsChanges = [[NSMutableArray alloc] init];
		for(NSDictionary *frownsUpdate in frownsUpdates){
			SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownsUpdate withContext:context];
			[frownsChanges addObject:frown];
			updated = YES;
		}
		[changeLog setObject:frownsChanges forKey:@"frowns"];
	}
	
	[changeLog setObject:[NSNumber numberWithBool:updated] forKey:@"has_updates"];
	
	[updates addObject:changeLog];
	
	// save the context so that if the user quits the app all records will work with sync date
	
	NSError * saveError;
	[context save:&saveError];
	[SNFDateManager unlock];
	
	if(saveError) {
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		[[NSNotificationCenter defaultCenter] postNotificationName:SNFSyncServiceError object:saveError];
		return completion(saveError, nil);
	}
	
	[self syncPredefinedBoardsWithCompletion:^(NSError *error, NSObject *boardData) {
		
		[[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
		
		if(error) {
			return completion(error, nil);
		} else {
			completion(saveError, updates);
		}
		
	}];
}



- (void)syncPredefinedBoardsWithCompletion:(SNFSyncServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"predefined_boards/sync"];
	NSURLSession *session = self.session;
	NSURLSessionTask *task = [session dataTaskWithURL:serviceURL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
		//dispatch_sync(dispatch_get_main_queue(), ^{
			if(error){
				NSLog(@"error: %@",error);
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
				[self updatePredefinedRecordsWithResults:(NSDictionary *)infoDict andCallCompletion:completion];
			}else{
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"expected dictionary"], nil);
			}
		//});
	}];
	[task resume];
}

- (void)updatePredefinedRecordsWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSArray *remotePredefinedBehaviors = [results objectForKey:@"behaviors"];
	NSArray *remotePredefinedBoards = [results objectForKey:@"boards"];
	NSArray *remotePredefinedBehaviorGroups = [results objectForKey:@"behavior_groups"];
	
	
	NSMutableArray *behaviorsReturned = [[NSMutableArray alloc] init];
	NSMutableArray *boardsReturned = [[NSMutableArray alloc] init];
	NSMutableArray *groupsReturned = [[NSMutableArray alloc] init];
	NSDictionary *returnData = @{
								 @"behaviors": behaviorsReturned,
								 @"boards": boardsReturned,
								 @"groups": groupsReturned,
								 };
	
	
	for(NSDictionary *behaviorInfo in remotePredefinedBehaviors){
		SNFPredefinedBehavior *behavior = (SNFPredefinedBehavior *)[SNFPredefinedBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
		if(behavior){
			[behaviorsReturned addObject:behavior];
		}
	}
	
	for(NSDictionary *boardInfo in remotePredefinedBoards){
		SNFPredefinedBoard *board = (SNFPredefinedBoard *)[SNFPredefinedBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
		NSMutableArray *boardBehaviors = [[NSMutableArray alloc] init];
		for(NSDictionary *behaviorInfo in [boardInfo objectForKey:@"behaviors"]){
			SNFPredefinedBehavior *behavior = (SNFPredefinedBehavior *)[SNFPredefinedBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
			[boardBehaviors addObject:behavior];
		}
		board.behaviors = [[NSSet alloc] initWithArray:boardBehaviors];
		if(board){
			[boardsReturned addObject:board];
		}
	}
	
	for(NSDictionary *groupInfo in remotePredefinedBehaviorGroups){
		SNFPredefinedBehaviorGroup *group = (SNFPredefinedBehaviorGroup *)[SNFPredefinedBehaviorGroup editOrCreatefromInfoDictionary:groupInfo withContext:context];
		NSMutableArray *groupBehaviors = [[NSMutableArray alloc] init];
		for(NSDictionary *behaviorInfo in [groupInfo objectForKey:@"behaviors"]){
			SNFPredefinedBehavior *behavior = (SNFPredefinedBehavior *)[SNFPredefinedBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
			[groupBehaviors addObject:behavior];
		}
		group.behaviors = [[NSSet alloc] initWithArray:groupBehaviors];
		if(group){
			[groupsReturned addObject:group];
		}
	}
	
	NSError *saveError;
	[context save:&saveError];
	if(saveError){
		return completion(saveError, nil);
	}
	completion(nil, returnData);
}

- (void)saveContext{
	if(_syncing){
		// save will happen at end of sync no need to do it.
		return;
	}
	NSError *error;
	[[SNFModel sharedInstance].managedObjectContext save:&error];
	if(error){
		NSLog(@"%@", error);
	}
}

@end
