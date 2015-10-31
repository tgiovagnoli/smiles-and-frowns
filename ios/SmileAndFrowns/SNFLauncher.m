
#import "SNFLauncher.h"
#import "AppDelegate.h"
#import "SNFTutorial.h"
#import "SNFModel.h"
#import "SNFLogin.h"
#import "SNFViewController.h"
#import "SNFAcceptInvite.h"
#import "NSTimer+Blocks.h"

@interface SNFLauncher ()
@property BOOL firstlayout;
@end

@implementation SNFLauncher

+ (BOOL) showAtLaunch {
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"ShowAtStartup":@(true)}];
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowAtStartup"];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	self.showOnStartup.on = [SNFLauncher showAtLaunch];
}

- (IBAction) showAtStartup:(id) sender {
	[[NSUserDefaults standardUserDefaults] setBool:self.showOnStartup.on forKey:@"ShowAtStartup"];
}

- (IBAction) acceptInvite:(id) sender {
	if(![SNFModel sharedInstance].loggedInUser) {
		
		SNFLogin * login = [[SNFLogin alloc] init];
		login.nextViewController = [[SNFAcceptInvite alloc] init];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
		
	} else {
		
		SNFViewController * root = [[SNFViewController alloc] init];
		root.firstTab = SNFTabInvites;
		[AppDelegate instance].window.rootViewController = root;
		
	}
}

- (IBAction) createBoard:(id)sender {
	if(![SNFModel sharedInstance].loggedInUser) {
		SNFLogin * login = [[SNFLogin alloc] init];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:SNFLoginDidLogin object:nil];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	} else {
		[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
	}
}

- (void) onLogin:(NSNotification *) note {
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SNFLoginDidLogin object:nil];
	[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
}

- (IBAction) viewTutorial:(id)sender {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
	tutorial.userInitiatedTutorial = TRUE;
	[AppDelegate instance].window.rootViewController = tutorial;
}

- (IBAction) login:(id) sender {
	[[AppDelegate rootViewController] presentViewController:[[SNFLogin alloc] init] animated:TRUE completion:nil];
}

@end
