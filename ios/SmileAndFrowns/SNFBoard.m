#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFReward.h"
#import "SNFUser.h"
#import "SNFUserRole.h"
#import "SNFModel.h"
#import "SNFPredefinedBoard.h"
#import "SNFPredefinedBehavior.h"

@implementation SNFBoard

+ (NSDictionary *)keyMappings{
	return @{
		@"title": @"title",
		@"soft_deleted": @"deleted",
		@"uuid": @"uuid",
		@"predefined_board_uuid":@"predefined_board_uuid",
		@"transaction_id": @"transaction_id",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"owner": @"owner",
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	self.uuid = [[NSUUID UUID] UUIDString];
	if(!self.predefined_board_uuid) {
		self.predefined_board_uuid = @"";
	}
	if(!self.title){
		self.title = @"Untitled";
	}
	[super awakeFromInsert];
}

- (void)addInitialRewards{
	NSDictionary *moneyReward = @{
									@"title": @"dollars",
									@"board": @{@"uuid": self.uuid},
									@"currency_amount": @0.25,
									@"smile_amount": @1,
									@"currency_type": SNFRewardCurrencyTypeMoney,
									};
	[SNFReward editOrCreatefromInfoDictionary:moneyReward withContext:self.managedObjectContext];
	
	NSDictionary *iPadReward = @{
								   @"title": @"minutes screen time",
								   @"board": @{@"uuid": self.uuid},
								   @"currency_amount": @20,
								   @"smile_amount": @10,
								   @"currency_type": SNFRewardCurrencyTypeTime,
								   };
	[SNFReward editOrCreatefromInfoDictionary:iPadReward withContext:self.managedObjectContext];
	
	NSDictionary *treatReward = @{
								 @"title": @"small treat",
								 @"board": @{@"uuid": self.uuid},
								 @"currency_amount": @1,
								 @"smile_amount": @10,
								 @"currency_type": SNFRewardCurrencyTypeTreat,
								 };
	[SNFReward editOrCreatefromInfoDictionary:treatReward withContext:self.managedObjectContext];
	
	NSDictionary *goalReward = @{
								  @"title": @"fun day trip",
								  @"board": @{@"uuid": self.uuid},
								  @"currency_amount": @1,
								  @"smile_amount": @20,
								  @"currency_type": SNFRewardCurrencyTypeGoal,
								  };
	[SNFReward editOrCreatefromInfoDictionary:goalReward withContext:self.managedObjectContext];
}

- (void) reset {
	
	for(SNFFrown *frown in self.frowns) {
		frown.soft_deleted = @YES;
	}
	
	for(SNFSmile *smile in self.smiles) {
		smile.soft_deleted = @YES;
	}
	
	for(SNFSmile *behavior in self.behaviors) {
		behavior.soft_deleted = @YES;
	}
	
	for(SNFReward *reward in self.rewards) {
		reward.soft_deleted = @YES;
	}
	
	for(SNFSmile *userRole in self.user_roles) {
		userRole.soft_deleted = @YES;
	}
	
	self.frowns = [NSSet set];
	self.smiles = [NSSet set];
	self.rewards = [NSSet set];
	self.behaviors = [NSSet set];
	self.user_roles = [NSSet set];
	
	[self addInitialRewards];
}

- (NSArray *) predefinedBoardBehaviors {
	if(self.predefined_board_uuid && ![self.predefined_board_uuid isEqual:[NSNull null]] && self.predefined_board_uuid.length > 0) {
		SNFPredefinedBoard * predefinedBoard = [SNFPredefinedBoard boardByUUID:self.predefined_board_uuid];
		if(predefinedBoard) {
			return [predefinedBoard.behaviors allObjects];
		}
	}
	return nil;
}

- (NSArray *) predefinedBehaviors {
	NSMutableArray * predefinedBehaviors = [NSMutableArray array];
	for(SNFBehavior * behavior in self.behaviors) {
		if(behavior.predefined_behavior_uuid && ![self.predefined_board_uuid isEqual:[NSNull null]] && self.predefined_board_uuid.length > 0) {
			[predefinedBehaviors addObject:behavior];
		}
	}
	return predefinedBehaviors;
}

+ (SNFBoard *) boardByUUID:(NSString *) uuid; {
	NSError * error = nil;
	NSFetchRequest * findRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * findEntity = [NSEntityDescription entityForName:@"SNFBoard" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
	[findRequest setEntity:findEntity];
	[findRequest setPredicate:[NSPredicate predicateWithFormat:@"uuid=%@", uuid]];
	NSArray * fetchedObjects = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:findRequest error:&error];
	if(error) {
		NSLog(@"fetch boardByUUID error: %@",error);
		return nil;
	}
	if(fetchedObjects.count > 0) {
		return [fetchedObjects objectAtIndex:0];
	}
	return nil;
}

+ (SNFBoard *)boardFromPredefinedBoard:(SNFPredefinedBoard *)pdb andContext:(NSManagedObjectContext *)context{
	NSDictionary *boardInfo;
	if(!pdb){
		boardInfo = @{@"title": @"Untitled", @"owner": [[SNFModel sharedInstance].loggedInUser infoDictionary]};
	}else{
		boardInfo = @{@"title": pdb.title, @"owner": [[SNFModel sharedInstance].loggedInUser infoDictionary]};
	}
	SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo withContext:context];
	board.predefined_board_uuid = pdb.uuid;
	for(SNFPredefinedBehavior *pdBehavior in pdb.behaviors){
		NSDictionary *behaviorInfo = @{
									   @"title": pdBehavior.title,
									   @"board": @{@"uuid": board.uuid},
									   @"positive": pdBehavior.positive,
									   };
		SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
		behavior.predefined_behavior_uuid = pdBehavior.uuid;
		NSLog(@"%@ - %@", behavior.title, behavior.positive);
	}
	[board addInitialRewards];
	return board;
}

- (NSArray *)sortedActiveBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.soft_deleted.boolValue){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *)sortedActivePositiveBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.soft_deleted.boolValue && behavior.positive.boolValue){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *)sortedActiveNegativeBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.soft_deleted.boolValue && !behavior.positive.boolValue){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *) sortedActiveRewards {
	NSArray *rewards = [self.rewards allObjects];
	NSMutableArray *activeRewards = [[NSMutableArray alloc] init];
	for(SNFBehavior * reward in rewards) {
		if(!reward.soft_deleted.boolValue) {
			[activeRewards addObject:reward];
		}
	}
	return [activeRewards sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.created_date" ascending:NO]]];
}

- (NSArray *) smilesForUser:(SNFUser *) user includeDeletedSmiles:(BOOL) includeDeletedSmiles includeCollectedSmiles:(BOOL) includeCollectedSmiles; {
	NSMutableArray * usersSmiles = [[NSMutableArray alloc] init];
	for(SNFSmile *smile in self.smiles) {
		if(smile.soft_deleted.boolValue && !includeDeletedSmiles) {
			continue;
		}
		if(smile.collected.boolValue && !includeCollectedSmiles) {
			continue;
		}
		if([smile.user.username isEqualToString:user.username]) {
			[usersSmiles addObject:smile];
		}
	}
	return usersSmiles;
}

- (NSArray *) frownsForUser:(SNFUser *)user includeDeletedFrowns:(BOOL)includeDeletedFrowns {
	NSMutableArray *usersFrowns = [[NSMutableArray alloc] init];
	
	for(SNFSmile *frown in self.frowns){
		
		if(frown.soft_deleted.boolValue && !includeDeletedFrowns) {
			continue;
		}
		
		if([frown.user.username isEqualToString:user.username]) {
			[usersFrowns addObject:frown];
		}
	}
	return usersFrowns;
}

- (NSInteger) smileCurrencyForUser:(SNFUser *) user {
	NSArray * smiles = [self smilesForUser:user includeDeletedSmiles:FALSE includeCollectedSmiles:FALSE];
	NSArray * frowns = [self frownsForUser:user includeDeletedFrowns:FALSE];
	return smiles.count - frowns.count;
}

- (NSString *)permissionForUser:(SNFUser *)user{
	if([self.owner.username isEqualToString:user.username]){
		return @"owner";
	}
	for(SNFUserRole *userRole in self.user_roles){
		if([userRole.user.username isEqualToString:user.username]){
			return userRole.role;
		}
	}
	return nil;
}



@end
