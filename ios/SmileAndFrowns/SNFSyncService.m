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

- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	
	NSMutableArray *updates = [[NSMutableArray alloc] init];
	
	NSString *syncString = [results objectForKey:@"sync_date"];
	NSArray *remoteChanges = [results objectForKey:@"data"];
	for(NSDictionary *changeData in remoteChanges){
		NSMutableDictionary *changeLog = [[NSMutableDictionary alloc] init];
		// update board
		NSDictionary *boardUpdates = [changeData valueForKey:@"board"];
		SNFBoard *board;
		if(boardUpdates){
			board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardUpdates withContext:context];
			[changeLog setObject:board forKey:@"board"];
		}
		if(!board){
			continue;
		}
		// update behaviors
		NSArray *behaviorUpdates = [changeData valueForKey:@"behaviors"];
		if(behaviorUpdates){
			NSMutableArray *behaviorChanges = [[NSMutableArray alloc] init];
			for(NSDictionary *behaviorUpdate in behaviorUpdates){
				SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorUpdate withContext:context];
				behavior.board = board;
				[behaviorChanges addObject:behavior];
			}
			[changeLog setObject:behaviorChanges forKey:@"behaviors"];
		}
		// update rewards
		NSArray *rewardsUpdates = [changeData valueForKey:@"rewards"];
		if(rewardsUpdates){
			NSMutableArray *rewardChanges = [[NSMutableArray alloc] init];
			for(NSDictionary *rewardsUpdate in rewardsUpdates){
				SNFReward *reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardsUpdate withContext:context];
				reward.board = board;
				[rewardChanges addObject:reward];
			}
			[changeLog setObject:rewardChanges forKey:@"rewards"];
		}
		// update smiles
		NSArray *smilesUpdates = [changeData valueForKey:@"smiles"];
		if(smilesUpdates){
			NSMutableArray *smilesChanges = [[NSMutableArray alloc] init];
			for(NSDictionary *smilesUpdate in smilesUpdates){
				SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smilesUpdate withContext:context];
				smile.board = board;
				[smilesChanges addObject:smile];
			}
			[changeLog setObject:smilesChanges forKey:@"smiles"];
		}
		// update frowns
		NSArray *frownsUpdates = [changeData valueForKey:@"frowns"];
		if(frownsUpdates){
			NSMutableArray *frownsChanges = [[NSMutableArray alloc] init];
			for(NSDictionary *frownsUpdate in frownsUpdates){
				SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownsUpdate withContext:context];
				frown.board = board;
				[frownsChanges addObject:frown];
			}
			[changeLog setObject:frownsChanges forKey:@"frowns"];
		}
		[updates addObject:changeLog];
	}
	NSLog(@"%@", syncString);
	completion(nil, updates);
}

- (NSDictionary *)createPostInfoDictionary{
	NSMutableDictionary *postData = [[NSMutableDictionary alloc] init];
	NSDate *lastSyncDate = [[NSDate date] dateByAddingTimeInterval: -1209600.0];
	[postData setObject:[self collectionForEntityName:@"SNFBoard" sinceSyncDate:lastSyncDate] forKey:@"boards"];
	[postData setObject:[self collectionForEntityName:@"SNFUserRole" sinceSyncDate:lastSyncDate] forKey:@"user_roles"];
	[postData setObject:[self collectionForEntityName:@"SNFBehavior" sinceSyncDate:lastSyncDate] forKey:@"behaviors"];
	[postData setObject:[self collectionForEntityName:@"SNFReward" sinceSyncDate:lastSyncDate] forKey:@"rewards"];
	[postData setObject:[self collectionForEntityName:@"SNFSmile" sinceSyncDate:lastSyncDate] forKey:@"smiles"];
	[postData setObject:[self collectionForEntityName:@"SNFFrown" sinceSyncDate:lastSyncDate] forKey:@"frowns"];
	return postData;
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


@end
