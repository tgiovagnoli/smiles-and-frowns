
#import "SNFReportBehaviorGroup2.h"

@implementation SNFReportBehaviorGroup2

- (id) initWithBehaviorUUID:(NSString *) behaviorUUID; {
	self = [super init];
	self.behaviorUUID = behaviorUUID;
	self.objects = [NSMutableArray array];
	self.notes = [[NSMutableString alloc] initWithString:@""];
	return self;
}

- (void) addSmile:(SNFSmile *) object; {
	[self.objects addObject:object];
	if(object.note && object.note.length > 0) {
		if(![self.notes containsString:object.note]) {
			if(self.notes.length < 1) {
				[self.notes appendString:object.note];
			} else {
				[self.notes appendFormat:@", %@",object.note];
			}
		}
	}
}

- (void) addFrown:(SNFFrown *) object; {
	[self.objects addObject:object];
	if(object.note && object.note.length > 0) {
		if(![self.notes containsString:object.note]) {
			if(self.notes.length < 1) {
				[self.notes appendString:object.note];
			} else {
				[self.notes appendFormat:@", %@",object.note];
			}
		}
	}
}

@end
