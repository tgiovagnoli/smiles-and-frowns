
#import "SNFLauncher.h"
#import "AppDelegate.h"
#import "SNFTutorial.h"
#import "SNFModel.h"
#import "SNFLogin.h"

@interface SNFLauncher ()
@property BOOL firstlayout;
@end

@implementation SNFLauncher

+ (BOOL) showAtLaunch {
	//return TRUE;
	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"ShowAtStartup":@(true)}];
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowAtStartup"];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
	}
}

- (IBAction) showAtStartup:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:self.showOnStartup.state forKey:@"ShowAtStartup"];
}

- (IBAction) acceptInvite:(id)sender {
	if(![SNFModel sharedInstance].loggedInUser) {
		
	}
}

- (IBAction) createBoard:(id)sender {
	
}

- (IBAction) viewTutorial:(id)sender {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
	tutorial.userInitiatedTutorial = TRUE;
	[AppDelegate instance].window.rootViewController = tutorial;
}

- (IBAction) login:(id) sender {
	SNFLogin * login = [[SNFLogin alloc] init];
	[[AppDelegate instance].window.rootViewController presentViewController:login animated:TRUE completion:^{
		
	}];
}

@end
