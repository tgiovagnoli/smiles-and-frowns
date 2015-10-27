#import "SNFConfig.h"

@implementation SNFConfig

- (id)init{
	self = [super init];
	
	NSString *configName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"SNFConfig"];
	NSDictionary *configData = [[NSBundle mainBundle] objectForInfoDictionaryKey:configName];
	
	_serverURL = [NSURL URLWithString:[configData objectForKey:@"serverURL"]];
	_apiURL = [_serverURL URLByAppendingPathComponent:[configData objectForKey:@"apiPath"]];
	
	return self;
}

- (NSURL *)apiURLForPath:(NSString *)path{
	return [[self apiURL] URLByAppendingPathComponent:path];
}

@end
