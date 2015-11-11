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
		@"deleted": @"deleted",
		@"uuid": @"uuid",
		@"transaction_id": @"transaction_id",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"device_date": @"device_date",
		@"owner": @"owner"
	};
}

- (void) awakeFromInsert{
	self.updated_date = [NSDate date];
	self.created_date = [NSDate date];
	self.device_date = [NSDate date];
	self.uuid = [[NSUUID UUID] UUIDString];
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

- (void)reset{
	self.title = @"Untitled";
	for(SNFFrown *frown in self.frowns){
		frown.deleted = @YES;
	}
	for(SNFSmile *smile in self.smiles){
		smile.deleted = @YES;
	}
	for(SNFSmile *behavior in self.behaviors){
		behavior.deleted = @YES;
	}
	for(SNFReward *reward in self.rewards){
		reward.deleted = @YES;
	}
	for(SNFSmile *userRole in self.user_roles){
		userRole.deleted = @YES;
	}
	
	self.frowns = [NSSet set];
	self.smiles = [NSSet set];
	self.rewards = [NSSet set];
	self.behaviors = [NSSet set];
	self.user_roles = [NSSet set];
	self.title = @"Untitled";
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
	for(SNFPredefinedBehavior *pdBehavior in pdb.behaviors){
		NSDictionary *behaviorInfo = @{
									   @"title": pdBehavior.title,
									   @"board": @{@"uuid": board.uuid},
									   @"positive": pdBehavior.positive,
									   };
		[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
	}
	[board addInitialRewards];
	return board;
}

- (NSArray *)sortedActiveBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.deleted.boolValue){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *)sortedActivePositiveBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.deleted.boolValue && [behavior.positive boolValue]){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *)sortedActiveNegativeBehaviors{
	NSArray *behaviors = [self.behaviors allObjects];
	NSMutableArray *activeBehaviors = [[NSMutableArray alloc] init];
	for(SNFBehavior *behavior in behaviors){
		if(!behavior.deleted.boolValue && ![behavior.positive boolValue]){
			[activeBehaviors addObject:behavior];
		}
	}
	return [activeBehaviors sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.title" ascending:YES]]];
}

- (NSArray *)sortedActiveRewards{
	NSArray *rewards = [self.rewards allObjects];
	NSMutableArray *activeRewards = [[NSMutableArray alloc] init];
	for(SNFBehavior *reward in rewards){
		if(!reward.deleted.boolValue){
			[activeRewards addObject:reward];
		}
	}
	return [activeRewards sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"self.created_date" ascending:NO]]];
}

- (NSArray *)smilesForUser:(SNFUser *)user{
	NSMutableArray *usersSmiles = [[NSMutableArray alloc] init];
	for(SNFSmile *smile in self.smiles){
		if([smile.user.username isEqualToString:user.username] && !smile.deleted.boolValue){
			[usersSmiles addObject:smile];
		}
	}
	return usersSmiles;
}

- (NSArray *)frownsForUser:(SNFUser *)user{
	NSMutableArray *usersFrowns = [[NSMutableArray alloc] init];
	for(SNFSmile *frown in self.frowns){
		if([frown.user.username isEqualToString:user.username] && !frown.deleted.boolValue){
			[usersFrowns addObject:frown];
		}
	}
	return usersFrowns;
}

- (NSInteger)smileCurrencyForUser:(SNFUser *)user{
	NSInteger smileCurrency = 0;
	NSArray *smiles = [self smilesForUser:user];
	SNFSmile *smile;
	for(smile in smiles){
		if(!smile.collected.boolValue){
			smileCurrency += 1;
		}
	}
	NSArray *frowns = [self frownsForUser:user];
	SNFFrown *frown;
	for(frown in frowns){
		smileCurrency -= 1;
	}
	return smileCurrency;
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
