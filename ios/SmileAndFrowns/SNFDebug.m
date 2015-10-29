#import "SNFDebug.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "SNFFrown.h"
#import "SNFSmile.h"
#import "SNFBehavior.h"
#import "SNFReward.h"
#import "SNFUser.h"
#import "SNFUserRole.h"
#import "SNFInvite.h"
#import "SNFSyncService.h"
#import "SNFUserService.h"
#import "APDDjangoErrorViewer.h"

@implementation SNFDebug

- (void)viewDidLoad {
    [super viewDidLoad];
	// TODO: Apple reccomends modifying dates using notifications instead of overriding the save command.  Need to put this somewhere it makes sense.
	// 
	
	[self insertItemWithName:@"Create/Update From Dictionaries" andSelector:@selector(createFromDictionaries)];
	[self insertItemWithName:@"Create Unique Board" andSelector:@selector(createUniqueBoard)];
	[self insertItemWithName:@"Save Managed Context" andSelector:@selector(save)];
	[self insertItemWithName:@"Sync" andSelector:@selector(sync)];
	[self insertItemWithName:@"Login" andSelector:@selector(login)];
	[self insertItemWithName:@"Logout" andSelector:@selector(logout)];
	
	
	[self insertItemWithName:@"Log Boards" andSelector:@selector(logBoards)];
	[self insertItemWithName:@"Log Rewards" andSelector:@selector(logRewards)];
	[self insertItemWithName:@"Log Behaviors" andSelector:@selector(logBehaviors)];
	[self insertItemWithName:@"Log Smiles" andSelector:@selector(logSmiles)];
	[self insertItemWithName:@"Log Frowns" andSelector:@selector(logFrowns)];
	[self insertItemWithName:@"Log User Roles" andSelector:@selector(logUserRoles)];
}

- (void)login{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService loginWithEmail:@"info@apptitude-digital.com" andPassword:@"abc123$" withCompletion:^(NSError *error, SNFUser *userInfo) {
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[self presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
			
		}else{
			[self alertWithMessage:[NSString stringWithFormat:@"logged in %@", userInfo.email]];
		};
	}];
}

- (void)logout{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService logoutWithCompletion:^(NSError *error) {
		if(error){
			[self alertWithMessage:error.localizedDescription];
		}else{
			[self alertWithMessage:@"logged out"];
		}
	}];
}

- (void)sync{
	SNFSyncService *syncService = [[SNFSyncService alloc] init];
	[syncService syncWithCompletion:^(NSError *error, NSObject *boardData) {
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[self presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
		}else{
			[self alertWithMessage:@"sync complete"];
		}
	}];
}

- (void)alertWithMessage:(NSString *)message{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]];
	[self presentViewController:alert animated:YES completion:^{}];
}

- (void)createFromDictionaries{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		if(user){
			NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
			
			NSDictionary *boardInfo = @{
										@"edit_count": @1,
										@"uuid": @"sample-board-uuid",
										@"title": @"Custom Board Created on Device",
										@"deleted": @NO,
										@"device_date": @"2015-10-21T21:20:38Z",
										@"created_date": @"2015-10-21T21:20:38Z",
										@"id": @1
										};
			SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
			board.owner = user;
			
			NSDictionary *userRoleInfo = @{
										   @"uuid": @"sample-user-role-uuid",
										   @"user": @{@"username": user.username},
										   @"role": @"parent",
										   @"board": @{@"uuid": board.uuid},
										   @"id": @1
										   };
			SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:userRoleInfo withContext:context];
			
			NSDictionary *inviteInfo = @{
								   @"uuid": @"sample-invite-uuid",
								   @"code": @"sample-code",
								   @"role": @{@"uuid": userRole.uuid},
								   @"board": @{@"uuid": board.uuid},
								   @"id": @1
								   };
			SNFInvite *invite = (SNFInvite *)[SNFInvite editOrCreatefromInfoDictionary:inviteInfo withContext:context];
			
			
			NSDictionary *behaviorInfo = @{
										   @"uuid": @"sample-behavior-uuid",
										   @"title": @"Cleaning up room",
										   @"deleted": @NO,
										   @"note": @"",
										   @"device_date": @"2015-10-21T21:34:54Z",
										   @"created_date": @"2015-10-21T21:34:54Z",
										   @"board": @{@"uuid": board.uuid},
										   @"id": @1
										   };
			SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
			
			NSDictionary *rewardInfo = @{
										 @"smile_amount": @1.0,
										 @"uuid": @"sample-reward-uuid",
										 @"title": @"Dollars",
										 @"deleted": @NO,
										 @"currency_type": @"money",
										 @"device_date": @"2015-10-21T21:37:01Z",
										 @"created_date": @"2015-10-21T21:37:01Z",
										 @"currency_amount": @0.25,
										 @"board": @{@"uuid": board.uuid},
										 @"id": @1
										 };
			SNFReward *reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardInfo withContext:context];
			
			NSDictionary *frownInfo = @{
										@"uuid": @"sample-frown-uuid",
										@"deleted": @NO,
										@"device_date": @"2015-10-21T21:20:38Z",
										@"created_date": @"2015-10-21T21:20:38Z",
										@"id": @1,
										@"board": @{@"uuid": board.uuid,},
										@"behavior": @{@"uuid": behavior.uuid},
										@"user": @{@"username": user.username},
										};
			SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownInfo withContext:context];
			
			NSDictionary *smileInfo = @{
										@"uuid": @"sample-smile-uuid",
										@"deleted": @NO,
										@"device_date": @"2015-10-21T21:20:38Z",
										@"created_date": @"2015-10-21T21:20:38Z",
										@"id": @1,
										@"board": @{@"uuid": board.uuid,},
										@"behavior": @{@"uuid": behavior.uuid},
										@"user": @{@"username": user.username},
										};
			SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smileInfo withContext:context];
			
			NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@", user, userRole, invite, reward, behavior, smile, frown, board);
		}else if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[self presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
		}
	}];
}

- (void)createUniqueBoard{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		if(user){
			NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
			
			NSDictionary *boardInfo = @{@"title": @"Custom Board Created on Device"};
			SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
			board.owner = user;
			
			// add a random user
			NSDictionary *userInfo = @{
							@"gender": SNFUserGenderMale,
							};
			SNFUser *childUser = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:userInfo withContext:context];
			
			NSDictionary *userRoleInfo = @{
										   @"user": @{@"username": user.username},
										   @"board": @{@"uuid": board.uuid},
										   };
			SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:userRoleInfo withContext:context];
			
			
			NSDictionary *userRoleInfo2 = @{
										   @"user": @{@"username": childUser.username},
										   @"role": SNFUserRoleChild,
										   @"board": @{@"uuid": board.uuid},
										   };
			SNFUserRole *userRole2 = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:userRoleInfo2 withContext:context];
			
			
			NSDictionary *inviteInfo = @{
								   @"role": @{@"uuid": userRole.uuid},
								   @"board": @{@"uuid": board.uuid},
								   };
			SNFInvite *invite = (SNFInvite *)[SNFInvite editOrCreatefromInfoDictionary:inviteInfo withContext:context];
			
			NSDictionary *behaviorInfo = @{
										   @"board": @{@"uuid": board.uuid},
										   };
			SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
			
			NSDictionary *rewardInfo = @{
										 @"board": @{@"uuid": board.uuid},
										 };
			SNFReward *reward = (SNFReward *)[SNFReward editOrCreatefromInfoDictionary:rewardInfo withContext:context];
			
			NSDictionary *frownInfo = @{
										@"board": @{@"uuid": board.uuid,},
										@"behavior": @{@"uuid": behavior.uuid},
										@"user": @{@"username": user.username},
										};
			SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownInfo withContext:context];
			
			NSDictionary *smileInfo = @{
										@"board": @{@"uuid": board.uuid,},
										@"behavior": @{@"uuid": behavior.uuid},
										@"user": @{@"username": user.username},
										};
			SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smileInfo withContext:context];
			
			NSLog(@"%@ %@ %@ %@ %@ %@ %@ %@ %@", user, userRole, userRole2, invite, reward, behavior, smile, frown, board);
		}else if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[self presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
		}
	}];
}

- (void)save{
	NSError *error;
	[[SNFModel sharedInstance].managedObjectContext save:&error];
	if(error){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Something went wrong trying to save." preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}]];
		[self presentViewController:alert animated:YES completion:^{}];
	}
}

- (void)logSmiles{
	[self logInfoForType:@"SNFSmile"];
}

- (void)logFrowns{
	[self logInfoForType:@"SNFFrown"];
}

- (void)logBoards{
	[self logInfoForType:@"SNFBoard"];
}

- (void)logBehaviors{
	[self logInfoForType:@"SNFBehavior"];
}

- (void)logRewards{
	[self logInfoForType:@"SNFReward"];
}

- (void)logUserRoles{
	[self logInfoForType:@"SNFUserRole"];
}

- (void)logInfoForType:(NSString *)type{
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:type];
	NSArray *results = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:request error:&error];
	NSLog(@"\n\n%@s:\n------------------------------------------------------\n", type);
	for(NSManagedObject *result in results){
		NSLog(@"\n%@", [result infoDictionaryWithChildrenAsUIDs]);
	}
}

- (void)objectContextWillSave:(NSNotification *)notification{
	NSManagedObjectContext *context = [notification object];
	NSSet *allModified = [context.insertedObjects setByAddingObjectsFromSet:context.updatedObjects];
	NSDate *now = [NSDate date];
	for(NSManagedObject *object in allModified){
		if([object respondsToSelector:NSSelectorFromString(@"updated_date")]){
			[object setValue:now forKey:@"updated_date"];
		}
	}
}



@end
