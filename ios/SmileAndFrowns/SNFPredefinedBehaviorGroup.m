#import "SNFPredefinedBehaviorGroup.h"
#import "SNFPredefinedBehavior.h"

@implementation SNFPredefinedBehaviorGroup

+ (NSDictionary *)keyMappings{
	return @{
			 @"uuid": @"uuid",
			 @"title": @"title",
			 @"soft_delete":@"soft_delete",
			 };
}

- (NSArray *)positiveBehaviors{
	NSMutableArray *positiveBehaviors = [[NSMutableArray alloc] init];
	for(SNFPredefinedBehavior *behavior in self.behaviors){
		if([behavior.positive boolValue]){
			[positiveBehaviors addObject:behavior];
		}
	}
	return [NSArray arrayWithArray:positiveBehaviors];
}

- (NSArray *)negativeBehaviors{
	NSMutableArray *negativeBehaviors = [[NSMutableArray alloc] init];
	for(SNFPredefinedBehavior *behavior in self.behaviors){
		if(![behavior.positive boolValue]){
			[negativeBehaviors addObject:behavior];
		}
	}
	return [NSArray arrayWithArray:negativeBehaviors];
}


@end
