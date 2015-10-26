
#import <Foundation/Foundation.h>

@interface NSDate (ISO8601)

//supports ISO8601 format: YYYY-MM-DD:HH:MM:SSZ
+ (NSDate *) dateFromISO8601String:(NSString *) dateString;

//returns ISO8601 date string format YYYY-MM-DD:HH:MM:SSZ in UTC like 2015-02-12T07:06:04+0000
- (NSString *) ISO8601DateStringUTC;

//returns ISO8601 date string format YYYY-MM-DD:HH:MM:SSZ in local timezone like 2015-02-11T23:06:04-0800
- (NSString *) ISO8601DateStringLocal;

@end
