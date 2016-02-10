
#import "SNFReportSection.h"

@implementation SNFReportSection

- (id) init {
	self = [super init];
	self.behaviorGroups = [NSMutableArray array];
	return self;
}

- (void) addSmile:(SNFSmile *) smile; {
	BOOL found = FALSE;
	for(SNFReportBehaviorGroup2 * group in self.behaviorGroups) {
		if(group.type == SNFReportBehaviorGroup2TypeSmile && [group.behaviorUUID isEqualToString:smile.behavior.uuid]) {
			[group addSmile:smile];
			//[group.objects addObject:smile];
			found = TRUE;
		}
	}
	if(!found) {
		SNFReportBehaviorGroup2 * group = [[SNFReportBehaviorGroup2 alloc] initWithBehaviorUUID:smile.behavior.uuid];
		group.type = SNFReportBehaviorGroup2TypeSmile;
		//[group.objects addObject:smile];
		[group addSmile:smile];
		[self.behaviorGroups addObject:group];
	}
}

- (void) addFrown:(SNFFrown *) frown; {
	BOOL found = FALSE;
	for(SNFReportBehaviorGroup2 * group in self.behaviorGroups) {
		if(group.type == SNFReportBehaviorGroup2TypeFrown && [group.behaviorUUID isEqualToString:frown.behavior.uuid]) {
			//[group.objects addObject:frown];
			[group addFrown:frown];
			found = TRUE;
		}
	}
	if(!found) {
		SNFReportBehaviorGroup2 * group = [[SNFReportBehaviorGroup2 alloc] initWithBehaviorUUID:frown.behavior.uuid];
		group.type = SNFReportBehaviorGroup2TypeFrown;
		//[group.objects addObject:frown];
		[group addFrown:frown];
		[self.behaviorGroups addObject:group];
	}
}

@end
