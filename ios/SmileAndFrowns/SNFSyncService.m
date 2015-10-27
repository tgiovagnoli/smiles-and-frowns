#import "SNFSyncService.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFReward.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFUserRole.h"


@implementation SNFSyncService

- (void)syncFromRemoteWithBoards:(NSArray *)boards andCompletion:(SNFSyncServiceCallback)completion{
	NSURL *serviceURL = [[SNFModel sharedInstance].config apiURLForPath:@"sync"];
	
	NSMutableArray *boardInfo = [[NSMutableArray alloc] init];
	for(SNFBoard *board in boards){
		NSDictionary *infoDict = @{
								   @"uuid": board.uuid,
								   @"edit_count": board.edit_count,
								   @"sync_date": [board stringFromDate:board.updated_date]
								   };
		[boardInfo addObject:infoDict];
	}
	
	NSError *jsonError;
	NSData *jsonData = [NSJSONSerialization dataWithJSONObject:boardInfo options:0 error:&jsonError];
	if(jsonError){
		completion(jsonError, nil);
		return;
	}
	NSString *test = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
	NSLog(@"%@", test);
	
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
			if([infoDict isKindOfClass:[NSArray class]]){
				[self syncRemoteWithLocalUsingData:(NSArray *)infoDict andCompletion:completion];
			}else{
				completion([SNFError errorWithCode:SNFErrorCodeParseError andMessage:@"expected array"], nil);
				return;
			}
		});
	}];
	[task resume];
}

- (void)syncRemoteWithLocalUsingData:(NSArray *)infoDict andCompletion:(SNFSyncServiceCallback)completion{
	NSMutableArray *boards = [[NSMutableArray alloc] init];
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	for(NSDictionary *remoteBoardInfo in infoDict){
		SNFBoard *board;
		
		NSDictionary *boardData = [remoteBoardInfo objectForKey:@"board"];
		// load up info on the board or skip the rest
		if(boardData){
			board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardData withContext:context];
			[boards addObject:board];
		}else{
			NSLog(@"Could not find board data skipping");
			continue;
		}
		
		// user roles
		NSArray *remoteRoles = [remoteBoardInfo objectForKey:@"user_roles"];
		if(remoteRoles){
			for(NSDictionary *userRoleData in remoteRoles){
				SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:userRoleData withContext:context];
				userRole.board = board;
			}
		}
		
		// behaviors
		NSArray *remoteBehaviors = [remoteBoardInfo objectForKey:@"behaviors"];
		if(remoteBehaviors){
			for(NSDictionary *behaviorData in remoteBehaviors){
				SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorData withContext:context];
				behavior.board = board;
			}
		}
		
		// rewards
		NSArray *remoteRewards = [remoteBoardInfo objectForKey:@"rewards"];
		if(remoteRewards){
			for(NSDictionary *rewardData in remoteRewards){
				SNFReward *reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardData withContext:context];
				reward.board = board;
			}
		}
		
		// smiles
		NSArray *remoteSmiles = [remoteBoardInfo objectForKey:@"smiles"];
		if(remoteSmiles){
			for(NSDictionary *smileData in remoteSmiles){
				NSLog(@"%@", smileData);
				SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smileData withContext:context];
				smile.board = board;
			}
		}
		
		// frowns
		NSArray *remoteFrowns = [remoteBoardInfo objectForKey:@"frowns"];
		if(remoteFrowns){
			for(NSDictionary *frownData in remoteFrowns){
				SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownData withContext:context];
				frown.board = board;
			}
		}
	}
	completion(nil, boards);
}

@end
