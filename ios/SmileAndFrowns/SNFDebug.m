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

@implementation SNFDebug

- (void)viewDidLoad {
    [super viewDidLoad];
	[self startWatchingBoard];
	
	[self insertItemWithName:@"Create/Update From Dictionaries" andSelector:@selector(createFromDictionaries)];
	[self insertItemWithName:@"Save Managed Context" andSelector:@selector(save)];
	[self insertItemWithName:@"Show Info Dictionaries" andSelector:@selector(showInfoDictionariesForBoard)];
}

- (void)startWatchingBoard{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSDictionary *boardInfo = @{@"uuid": @"sample-board-uuid"};
	SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
	
	NSDictionary *mappings = [[board class] keyMappings];
	for(NSString *key in mappings){
		[board addObserver:self forKeyPath:key options:NSKeyValueObservingOptionNew context:nil];
	}
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	NSLog(@"%@ changed - %@", NSStringFromClass([object class]), keyPath);
}

- (void)createFromDictionaries{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	
	NSDictionary *boardInfo = @{
								@"updated_date": @"2015-10-21T21:20:38Z",
								@"edit_count": @1,
								@"uuid": @"sample-board-uuid",
								@"title": @"Custom Board",
								@"deleted": @NO,
								@"device_date": @"2015-10-21T21:20:38Z",
								@"created_date": @"2015-10-21T21:20:38Z",
								@"id": @1
								};
	SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
	
	NSDictionary *userInfo = @{
							   @"first_name": @"Malcolm",
							   @"last_name": @"Wilson",
							   @"username": @"sample-username-uuid",
							   @"age": @22,
							   @"gender": @"Male",
							   @"id": @1
							   };
	
	SNFUser *user = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:userInfo withContext:context];
	
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
								   @"updated_date": @"2015-10-21T21:34:54Z",
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
								 @"updated_date": @"2015-10-21T21:37:01Z",
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
								@"updated_date": @"2015-10-21T21:20:38Z",
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
								@"updated_date": @"2015-10-21T21:20:38Z",
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

- (void)showInfoDictionariesForBoard{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSDictionary *boardInfo = @{@"uuid": @"sample-board-uuid"};
	SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
	
	NSLog(@"board data: %@", [board infoDictionary]);
	
	for(SNFReward *reward in board.rewards){
		NSLog(@"reward data: %@", [reward infoDictionary]);
	}
	
	for(SNFBehavior *behavior in board.behaviors){
		NSLog(@"behavior data: %@", [behavior infoDictionary]);
	}
	
	for(SNFFrown *frown in board.frowns){
		NSLog(@"frown data: %@", [frown infoDictionary]);
	}
	
	for(SNFSmile *smile in board.smiles){
		NSLog(@"smile data: %@", [smile infoDictionary]);
	}
	
	for(SNFInvite *invite in board.invites){
		NSLog(@"invite data: %@", [invite infoDictionary]);
	}
	
	for(SNFUserRole *userRole in board.user_roles){
		NSLog(@"user role data: %@", [userRole infoDictionary]);
	}
	
}


@end
