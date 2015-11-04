#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFInvite.h"
#import "SNFReward.h"

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

@end
