
#import "SNFReportDataProvider.h"

@interface SNFReportDataProvider ()
@end

@implementation SNFReportDataProvider

- (id) initWithWindowStart:(NSTimeInterval) start windowEnd:(NSTimeInterval) end weeks:(NSInteger) weeks maxWeeks:(NSInteger) maxWeeks; {
	self = [super init];
	self.sections = [NSMutableArray array];
	self.windowStart = start;
	self.windowEnd = end;
	self.weeks = weeks;
	self.maxWeeks = maxWeeks;
	return self;
}

- (void) resetWindowStart:(NSTimeInterval) start windowEnd:(NSTimeInterval) end weeks:(NSInteger) weeks maxWeeks:(NSInteger) maxWeeks; {
	self.windowStart = start;
	self.windowEnd = end;
	self.weeks = weeks;
	self.maxWeeks = maxWeeks;
}

- (void) sortSectionsByWeek; {
	[self.sections sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		SNFReportSection * section1 = (SNFReportSection *)obj1;
		SNFReportSection * section2 = (SNFReportSection *)obj2;
		if(section1.weeks  > section2.weeks) {
			return NSOrderedAscending;
		}
		return NSOrderedDescending;
	}];
}

- (BOOL) shouldContinue; {
	if(self.weeks > self.maxWeeks) {
		return FALSE;
	}
	return TRUE;
}

- (BOOL) shouldMoveWindow:(NSTimeInterval) smileFrownCreatedDate; {
	if(smileFrownCreatedDate < self.windowStart) {
		return TRUE;
	}
	return FALSE;
}

- (void) moveWindow {
	//moves window back in time by two weeks.
	self.weeks += self.weeks;
	self.windowStart -= 604800*self.weeks;
	self.windowEnd -= 604800*self.weeks;
}

- (void) addSmile:(SNFSmile *) smile {
	BOOL foundSection = FALSE;
	for(SNFReportSection * section in self.sections) {
		if([section wasCreatedInWindow:smile.created_date]) {
			[section addSmile:smile];
			foundSection = TRUE;
		}
	}
	if(!foundSection) {
		SNFReportSection * section = [[SNFReportSection alloc] init];
		section.weeks = self.weeks;
		section.start = self.windowStart;
		section.end = self.windowEnd;
		[section addSmile:smile];
		[self.sections addObject:section];
	}
}

- (void) addFrown:(SNFFrown *) frown {
	BOOL foundSection = FALSE;
	for(SNFReportSection * section in self.sections) {
		if([section wasCreatedInWindow:frown.created_date]) {
			[section addFrown:frown];
			foundSection = TRUE;
		}
	}
	if(!foundSection) {
		SNFReportSection * section = [[SNFReportSection alloc] init];
		section.weeks = self.weeks;
		section.start = self.windowStart;
		section.end = self.windowEnd;
		[section addFrown:frown];
		[self.sections addObject:section];
	}
}

@end
