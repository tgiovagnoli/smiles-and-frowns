#import "SNFUserSettings.h"

@implementation SNFUserSettings

- (id)init{
	self = [super init];
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	_lastSyncDate = [defaults objectForKey:@"lastSyncDate"];
	return self;
}

- (void)setLastSyncDate:(NSDate *)lastSyncDate{
	_lastSyncDate = lastSyncDate;
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	[defaults setObject:_lastSyncDate forKey:@"lastSyncDate"];
	[defaults synchronize];
}

@end
