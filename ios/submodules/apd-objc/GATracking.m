
#import "GATracking.h"

static id <GAITracker> _tracker;
static BOOL _sessionStarted = FALSE;

@interface GATrackingLogger : NSObject <TAGLogger>
@property TAGLoggerLogLevelType logLevel;
- (void) error:(NSString *) message;
- (void) warning:(NSString *) message;
- (void) info:(NSString *) message;
- (void) debug:(NSString *) message;
- (void) verbose:(NSString *) message;
@end
@implementation GATrackingLogger
- (void)error:(NSString *)message {
	NSLog(@"Error: %@", message);
}
- (void)warning:(NSString *)message {
	NSLog(@"Warning: %@", message);
}
- (void)info:(NSString *)message {
	NSLog(@"Info: %@", message);
}
- (void)debug:(NSString *)message {
	NSLog(@"Debug: %@", message);
}
- (void)verbose:(NSString *)message {
	NSLog(@"Verbose: %@", message);
}
@end

@interface GATracking ()
@property NSMutableArray * delayedCalls;
@end

@implementation GATracking

+ (GATracking *) instance; {
	static GATracking * _instance = nil;
	if(!_instance) {
		_instance = [[GATracking alloc] init];
	}
	return _instance;
}

+ (GATracking *) tagManager {
	return [GATracking instance];
}

+ (void) initializeGoogleAnalyticsWithKey:(NSString *) key allowIDFACollection:(BOOL) allowIDFACollection {
	if(!key || key.length < 1) {
		return;
	}
	[GAI sharedInstance].trackUncaughtExceptions = NO;
	[GAI sharedInstance].dispatchInterval = 20;
	[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelError];
	[[GAI sharedInstance] trackerWithTrackingId:key];
	_tracker = [[GAI sharedInstance] defaultTracker];
	_tracker.allowIDFACollection = allowIDFACollection;
}

//http://stackoverflow.com/questions/18855490/session-control-with-google-analytics-api-v3-for-ios
+ (void) startSession {
	if(!_sessionStarted) {
		_sessionStarted = TRUE;
		NSMutableDictionary * pams = [[GAIDictionaryBuilder createEventWithCategory:@"Session" action:@"Start" label:nil value:0] build];
		[_tracker set:kGAISessionControl value:@"start"];
		[_tracker send:pams];
		[_tracker set:kGAISessionControl value:nil];
	}
}

//http://stackoverflow.com/questions/18855490/session-control-with-google-analytics-api-v3-for-ios
+ (void) endSession {
	_sessionStarted = FALSE;
	NSMutableDictionary * pams = [[GAIDictionaryBuilder createEventWithCategory:@"Session" action:@"End" label:nil value:0] build];
	[_tracker set:kGAISessionControl value:@"end"];
	[_tracker send:pams];
}

+ (void) trackScreen:(NSString *) screen {
	[_tracker set:kGAIScreenName value:screen];
	[_tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

+ (void) trackEventWithCategory:(NSString *) category action:(NSString *) action label:(NSString *) label andValue:(NSInteger) val {
	NSMutableDictionary * pams = [[GAIDictionaryBuilder createEventWithCategory:category action:action label:label value:@(val)] build];
	[_tracker send:pams];
}

+ (void) trackEventWithCategory:(NSString *) category action:(NSString *) action label:(NSString *) label {
	[GATracking trackEventWithCategory:category action:action label:label andValue:0];
}

- (void) initTagManagerWithID:(NSString *) tagManagerId; {
	[TAGContainerOpener openContainerWithId:tagManagerId tagManager:[TAGManager instance] openType:kTAGOpenTypePreferFresh timeout:nil notifier:self];
	[TAGManager instance].logger = [[GATrackingLogger alloc] init];
	[[TAGManager instance].logger setLogLevel:kTAGLoggerLogLevelInfo];
	[NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(refreshContainer:) userInfo:nil repeats:TRUE];
	self.delayedCalls = [NSMutableArray array];
}

- (void) setLogLevel:(TAGLoggerLogLevelType) logLevel; {
	if(logLevel == kTAGLoggerLogLevelNone) {
		[TAGManager instance].logger = nil;
	} else {
		if(![TAGManager instance].logger) {
			[TAGManager instance].logger = [[GATrackingLogger alloc] init];
		}
		[[TAGManager instance].logger setLogLevel:logLevel];
	}
}

- (void) refreshContainer:(NSTimer *)timer {
	if(self.container) {
		[self.container refresh];
	}
	[self sendDelayedCalls];
}

- (void) sendDelayedCalls {
	if(!self.container) {
		return;
	}
	
	TAGDataLayer * dataLayer = [TAGManager instance].dataLayer;
	if(self.delayedCalls.count > 0) {
		for(NSDictionary * call in self.delayedCalls) {
			[dataLayer push:call];
		}
	}
	[self.delayedCalls removeAllObjects];
}

- (void) containerAvailable:(TAGContainer *) container {
	dispatch_async(dispatch_get_main_queue(), ^{
		self.container = container;
	});
}

- (void) trackEventWithTagManager:(NSString *) event parameters:(NSDictionary *) parameters; {
	[self trackEvent:event parameters:parameters];
}

- (void) trackEvent:(NSString *)event parameters:(NSDictionary *)parameters {
	NSMutableDictionary * combined = [NSMutableDictionary dictionaryWithDictionary:parameters];
	combined[@"event"] = event;
	NSLog(@"trackEventWithTagManager: %@",combined);
	TAGDataLayer * dataLayer = [TAGManager instance].dataLayer;
	if(!self.container) {
		[[self delayedCalls] addObject:combined];
		return;
	}
	[self sendDelayedCalls];
	[dataLayer push:combined];
}

- (void) trackEvent:(NSString *) event withCategory:(NSString *) category action:(NSString *) action label:(NSString *) label andValue:(NSString *) value {
	NSAssert(event != nil, @"Event must not be blank");
	NSAssert(category != nil, @"Category must not be blank");
	NSAssert(action != nil, @"Action must not be blank");
	
	NSMutableDictionary * params = [[NSMutableDictionary alloc] initWithCapacity:5];
	
	if(category) {
		[params setValue:category forKey:@"eventCategory"];
	}
	
	if(action) {
		[params setValue:action forKey:@"eventAction"];
	}
	
	if(label) {
		[params setValue:label forKey:@"eventLabel"];
	}
	
	if(value) {
		[params setValue:value forKey:@"eventValue"];
	}
	
	[self trackEventWithTagManager:event parameters:params];
}

- (void) pushCustomData:(NSDictionary *) data; {
	if(!self.container) {
		[[self delayedCalls] addObject:data];
		return;
	}
	[self sendDelayedCalls];
	TAGDataLayer * dataLayer = [TAGManager instance].dataLayer;
	[dataLayer push:data];
}

- (void) trackScreenWithTagManager:(NSString *) screenName; {
	[self trackScreen:screenName];
}

- (void) trackScreen:(NSString *) screenName; {
	[self trackEventWithTagManager:@"openScreen" parameters:@{@"screenName":screenName}];
}

@end
