
#import "SNFReportDataProvider.h"

@interface SNFReportDataProvider ()
@property NSTimeInterval now;
@property NSTimeInterval lastCreatedDate;
@end

@implementation SNFReportDataProvider

- (id) initWithMaxWeeks:(NSInteger) maxWeeks; {
	self = [super init];
	self.lastCreatedDate = 0;
	self.now = [[NSDate date] timeIntervalSince1970];
	self.sections = [NSMutableArray array];
	self.maxWeeks = maxWeeks;
	return self;
}

- (void) sortSectionsBySectionIndex; {
	[self.sections sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
		SNFReportSection * section1 = (SNFReportSection *)obj1;
		SNFReportSection * section2 = (SNFReportSection *)obj2;
		if(section1.sectionIndex  > section2.sectionIndex) {
			return NSOrderedAscending;
		}
		return NSOrderedDescending;
	}];
	
	NSInteger week = 2;
	for(SNFReportSection * section in self.sections) {
		if(week > 2) {
			section.sectionHeaderTitle = [NSString stringWithFormat:@"Last %li-%li Weeks",week-2,week];
		} else {
			section.sectionHeaderTitle = [NSString stringWithFormat:@"Last 2 Weeks"];
		}
		week += 2;
	}
}

- (void) reset {
	self.lastCreatedDate = 0;
}

- (void) addSmile:(SNFSmile *) smile {
	
	NSLog(@"adding smile (%@)  days since now %g", smile.uuid ,(double) ([[NSDate date] timeIntervalSince1970] - [smile.created_date timeIntervalSince1970]) / 86400);
	
	NSTimeInterval createdTI = [smile.created_date timeIntervalSince1970];
	float days = (self.now - createdTI) / 86400;
	float weeks = days / 7;
	float sectionIndex = ceilf(days / 14) - 1;
	self.lastCreatedDate = createdTI;
	
	if(weeks > self.maxWeeks) {
		NSLog(@"smile too old, weeks: %f, maxweeks: %li",weeks,self.maxWeeks);
		return;
	}
	
	BOOL foundSection = FALSE;
	
	for(SNFReportSection * section in self.sections) {
		if(section.sectionIndex == sectionIndex) {
			[section addSmile:smile];
			foundSection = TRUE;
		}
	}
	
	if(!foundSection) {
		SNFReportSection * section = [[SNFReportSection alloc] init];
		section.sectionIndex = sectionIndex;
		[section addSmile:smile];
		[self.sections addObject:section];
	}
}

- (void) addFrown:(SNFFrown *) frown {
	NSTimeInterval createdTI = [frown.created_date timeIntervalSince1970];
	float days = (self.now - createdTI) / 86400;
	float weeks = days / 7;
	float sectionIndex = ceilf(days / 14) - 1;
	self.lastCreatedDate = createdTI;
	
	if(weeks > self.maxWeeks) {
		NSLog(@"frown too old, weeks: %f, maxweeks: %li",weeks,self.maxWeeks);
		return;
	}
	
	BOOL foundSection = FALSE;
	
	for(SNFReportSection * section in self.sections) {
		if(section.sectionIndex == sectionIndex) {
			[section addFrown:frown];
			foundSection = TRUE;
		}
	}
	
	if(!foundSection) {
		SNFReportSection * section = [[SNFReportSection alloc] init];
		section.sectionIndex = sectionIndex;
		[section addFrown:frown];
		[self.sections addObject:section];
	}
}

@end
