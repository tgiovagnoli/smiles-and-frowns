
#import "ATITwitterAuthHandler.h"
#import "SNFModel.h"

NSString * const ATITwitterAuthHandlerSessionChange = @"ATITwitterAuthHandlerSessionChange";

static ATITwitterAuthHandler *_instance;

@implementation ATITwitterAuthHandler

+ (ATITwitterAuthHandler *) instance {
	if(!_instance) {
		_instance = [[ATITwitterAuthHandler alloc] init];
	}
	return _instance;
}

- (id) init {
	self = [super init];
	[[Twitter sharedInstance] startWithConsumerKey:[SNFModel sharedInstance].config.twitterKey consumerSecret:[SNFModel sharedInstance].config.twitterSecret];
	return self;
}

- (void) login {
	[[Twitter sharedInstance] logInWithCompletion:^(TWTRSession * session, NSError * error) {
		if(session) {
			[[NSNotificationCenter defaultCenter] postNotificationName:ATITwitterAuthHandlerSessionChange object:self userInfo:@{@"session": session, @"twitter": [Twitter sharedInstance]}];
		} else {
			[[NSNotificationCenter defaultCenter] postNotificationName:ATITwitterAuthHandlerSessionChange object:self userInfo:@{@"error": error, @"twitter": [Twitter sharedInstance]}];
		}
	}];
}

- (void) logout {
	[[Twitter sharedInstance] logOut];
}

@end
