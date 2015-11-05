#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFInvite.h"
#import "SNFReward.h"
#import "SNFUser.h"

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
	if(self.rewards.count < 1){
		[self addInitialRewards];
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

@end
