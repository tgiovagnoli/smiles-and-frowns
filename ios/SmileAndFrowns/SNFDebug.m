
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
#import "SNFPredefinedBehaviorGroup.h"
#import "SNFPredefinedBehavior.h"
#import "SNFPredefinedBoard.h"
#import "SNFSyncService.h"
#import "SNFUserService.h"
#import "APDDjangoErrorViewer.h"
#import "AppDelegate.h"
#import "UIAlertAction+Additions.h"

@implementation SNFDebug

- (void)viewDidLoad {
    [super viewDidLoad];
	[self insertItemWithName:@"Create Unique Board" andSelector:@selector(createUniqueBoard)];
	[self insertItemWithName:@"Save Managed Context" andSelector:@selector(save)];
	[self insertItemWithName:@"Sync" andSelector:@selector(sync)];
	[self insertItemWithName:@"Reset Date and Sync" andSelector:@selector(resetAndSync)];
	[self insertItemWithName:@"Sync Predefined Boards" andSelector:@selector(syncPredefinedBoards)];
	[self insertItemWithName:@"Login" andSelector:@selector(login)];
	[self insertItemWithName:@"Logout" andSelector:@selector(logout)];
	
	[self insertItemWithName:@"Log Boards" andSelector:@selector(logBoards)];
	[self insertItemWithName:@"Log Rewards" andSelector:@selector(logRewards)];
	[self insertItemWithName:@"Log Behaviors" andSelector:@selector(logBehaviors)];
	[self insertItemWithName:@"Log Smiles" andSelector:@selector(logSmiles)];
	[self insertItemWithName:@"Log Frowns" andSelector:@selector(logFrowns)];
	[self insertItemWithName:@"Log User Roles" andSelector:@selector(logUserRoles)];
	[self insertItemWithName:@"Log Predefiend Info" andSelector:@selector(logInfoForPredefinedBoards)];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (void)login{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService loginWithEmail:@"info@apptitude-digital.com" andPassword:@"abc123$" withCompletion:^(NSError *error, SNFUser *userInfo) {
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[[AppDelegate rootViewController] presentViewController:viewer animated:YES completion:^{
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

- (void)resetAndSync{
	[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
	[self sync];
}

- (void)sync{
	SNFSyncService *syncService = [[SNFSyncService alloc] init];
	[syncService syncWithCompletion:^(NSError *error, NSObject *boardData) {
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[[AppDelegate rootViewController] presentViewController:viewer animated:YES completion:^{
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
	[alert addAction:[UIAlertAction OKAction]];
	[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
}

- (void)createUniqueBoard{
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		if(user){
			NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
			NSDictionary *boardInfo = @{@"title": @"Custom Board Created on Device"};
			SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
			board.owner = user;
		}else if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[[AppDelegate rootViewController] presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
		}
	}];
}


- (void)syncPredefinedBoards{
	SNFSyncService *syncService = [[SNFSyncService alloc] init];
	[syncService syncPredefinedBoardsWithCompletion:^(NSError *error, NSObject *boardData) {
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				APDDjangoErrorViewer *viewer = [[APDDjangoErrorViewer alloc] init];
				[[AppDelegate rootViewController] presentViewController:viewer animated:YES completion:^{
					[viewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
				}];
			}else{
				[self alertWithMessage:error.localizedDescription];
			}
		}else{
			[self alertWithMessage:@"predefined boards sync complete"];
		}
	}];
}

- (void)save{
	NSError *error;
	[[SNFModel sharedInstance].managedObjectContext save:&error];
	if(error){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Something went wrong trying to save." preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction OKAction]];
		[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:^{}];
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

- (void)logInfoForPredefinedBoards{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBoard"];
	NSArray *results = [context executeFetchRequest:request error:&error];
	NSLog(@"boards:");
	for(SNFPredefinedBoard *board in results){
		NSLog(@"\n%@", [board infoDictionaryWithChildrenAsUIDs]);
	}
	NSLog(@"behaviors:");
	request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBehavior"];
	results = [context executeFetchRequest:request error:&error];
	for(NSManagedObject *behavior in results){
		NSLog(@"\n%@", [behavior infoDictionaryWithChildrenAsUIDs]);
	}
	NSLog(@"behavior groups:");
	request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBehaviorGroup"];
	results = [context executeFetchRequest:request error:&error];
	for(NSManagedObject *result in results){
		NSLog(@"\n%@", [result infoDictionaryWithChildrenAsUIDs]);
	}
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

@end
