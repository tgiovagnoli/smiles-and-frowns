
#import "SNFLauncher.h"
#import "AppDelegate.h"
#import "SNFTutorial.h"

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
	
}

- (IBAction) createBoard:(id)sender {
	
}

- (IBAction) viewTutorial:(id)sender {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
	tutorial.userInitiatedTutorial = TRUE;
	[AppDelegate instance].window.rootViewController = tutorial;
}

- (IBAction) login:(id) sender {
	
}

@end
