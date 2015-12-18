
#import "SNFReportBehaviorGroup2.h"

@implementation SNFReportBehaviorGroup2

- (id) initWithBehaviorUUID:(NSString *) behaviorUUID; {
	self = [super init];
	self.behaviorUUID = behaviorUUID;
	self.objects = [NSMutableArray array];
	return self;
}

@end
