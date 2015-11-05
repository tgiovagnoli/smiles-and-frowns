#import "SNFReportingSectionHeader.h"

@implementation SNFReportingSectionHeader

- (void)setDateGroup:(SNFReportDateGroup *)dateGroup{
	_dateGroup = dateGroup;
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	dateFormatter.doesRelativeDateFormatting = YES;
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
	self.dateLabel.text = [dateFormatter stringFromDate:dateGroup.date];
}

@end
