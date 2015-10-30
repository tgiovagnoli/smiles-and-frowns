
#import "SNFLauncher.h"
#import "AppDelegate.h"
#import "SNFTutorial.h"
#import "SNFModel.h"
#import "SNFLogin.h"
#import "SNFViewController.h"
#import "SNFAcceptInvite.h"

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
}

- (IBAction) showAtStartup:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:self.showOnStartup.state forKey:@"ShowAtStartup"];
}

- (IBAction) acceptInvite:(id)sender {
	//[[AppDelegate rootViewController] presentViewController:[[SNFAcceptInvite alloc] init] animated:TRUE completion:nil];
	//return;
	
	if(![SNFModel sharedInstance].loggedInUser) {
		SNFLogin * login = [[SNFLogin alloc] init];
		login.nextViewController = [[SNFAcceptInvite alloc] init];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	} else {
		[[AppDelegate rootViewController] presentViewController:[[SNFAcceptInvite alloc] init] animated:TRUE completion:nil];
	}
}

- (IBAction) createBoard:(id)sender {
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
