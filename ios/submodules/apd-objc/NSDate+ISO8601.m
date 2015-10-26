
#import "NSDate+ISO8601.h"

@implementation NSDate (ISO8601)

+ (NSDate *) dateFromISO8601String:(NSString *) dateString; {
	NSDateFormatter * dateFormatter = [NSDateFormatter new];
	dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
	return [dateFormatter dateFromString:dateString];
}

- (NSString *) ISO8601DateStringUTC; {
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
	[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
	return [dateFormatter stringFromDate:self];
}

- (NSString *) ISO8601DateStringLocal; {
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeZone = [NSTimeZone localTimeZone];
	[dateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssZ"];
	return [dateFormatter stringFromDate:self];
}

@end
