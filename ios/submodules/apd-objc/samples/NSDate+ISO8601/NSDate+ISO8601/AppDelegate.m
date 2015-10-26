
#import "AppDelegate.h"
#import "NSDate+ISO8601.h"

@implementation AppDelegate

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	NSDate * now = [NSDate date];
	NSLog(@"now: %@",now);
	NSLog(@"utc iso8601 string: %@",[now ISO8601DateStringUTC]);
	NSLog(@"local timezone iso8601 string: %@",[now ISO8601DateStringLocal]);
	NSLog(@"local date: %@", [NSDate dateFromISO8601String: [now ISO8601DateStringLocal]]);
	NSLog(@"local date: %@", [NSDate dateFromISO8601String: [now ISO8601DateStringUTC]]);
	return YES;
}

@end
