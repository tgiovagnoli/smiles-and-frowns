
#import "SNFLauncher.h"
#import "AppDelegate.h"
#import "SNFTutorial.h"
#import "SNFModel.h"
#import "SNFLogin.h"
#import "SNFViewController.h"
#import "SNFAcceptInvite.h"
#import "NSTimer+Blocks.h"
#import "UIAlertAction+Additions.h"
#import "SNFCreateAccount.h"
#import "UIViewController+Alerts.h"
#import "SNFADBannerView.h"
#import "IAPHelper.h"

@interface SNFLauncher ()
@property BOOL firstlayout;
@property SNFADBannerView * bannerView;
@end

@implementation SNFLauncher

+ (BOOL) showAtLaunch {
	return FALSE;
//	[[NSUserDefaults standardUserDefaults] registerDefaults:@{@"ShowAtStartup":@(true)}];
//	return [[NSUserDefaults standardUserDefaults] boolForKey:@"ShowAtStartup"];
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	//[[SNFModel sharedInstance] addObserver:self forKeyPath:@"loggedInUser" options:NSKeyValueObservingOptionNew context:nil];
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLoginSyncComplete:) name:SNFLoginLogingSyncCompleted object:nil];
	
	if(![[IAPHelper defaultHelper] hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		self.bannerView = [[SNFADBannerView alloc] initWithAdType:ADAdTypeBanner];
		self.bannerView.delegate = self;
	}
	
	[self decorate];
	
	[[GATracking instance] trackScreenWithTagManager:@"LauncherView"];
}

- (void)decorate{
	for(UIButton *button in self.buttons){
		[SNFFormStyles roundEdgesOnButton:button];
	}
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
	}
}

- (void) dealloc {
	//[[SNFModel sharedInstance] removeObserver:self forKeyPath:@"loggedInUser"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	self.bottom.constant = 10;
	[self.bannerView removeFromSuperview];
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
	banner.y = self.view.height - banner.height;
	self.bottom.constant = banner.height + 10;
	[self.view addSubview:banner];
}

- (void) onLoginSyncComplete:(id) sender {
	[NSTimer scheduledTimerWithTimeInterval:.5 block:^{
		[self.bannerView removeFromSuperview];
		SNFViewController * vc = [[SNFViewController alloc] init];
		[AppDelegate instance].window.rootViewController = vc;
	} repeats:FALSE];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	if([keyPath isEqualToString:@"loggedInUser"]) {
		[NSTimer scheduledTimerWithTimeInterval:.5 block:^{
			[self.bannerView removeFromSuperview];
			SNFViewController * vc = [[SNFViewController alloc] init];
			[AppDelegate instance].window.rootViewController = vc;
		} repeats:FALSE];
	}
}

- (IBAction) acceptInvite:(id) sender {
	if(![SNFModel sharedInstance].loggedInUser) {
		
		SNFLogin * login = [[SNFLogin alloc] initWithSourceView:self.loginButton sourceRect:CGRectZero contentSize:CGSizeMake(500,420)];
		login.nextViewController = [[SNFAcceptInvite alloc] initWithSourceView:self.acceptInviteButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
		
	} else {
		
		SNFViewController * root = [[SNFViewController alloc] init];
		root.firstTab = SNFTabInvites;
		[AppDelegate instance].window.rootViewController = root;
		
	}
}

- (IBAction) createBoard:(id)sender {
	if(![SNFModel sharedInstance].loggedInUser) {
		SNFLogin * login = [[SNFLogin alloc] initWithSourceView:self.loginButton sourceRect:CGRectZero contentSize:CGSizeMake(500,420)];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	} else {
		[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
	}
}

- (IBAction) viewTutorial:(id)sender {
	SNFTutorial * tutorial = [SNFTutorial tutorialInstance];
	tutorial.userInitiatedTutorial = TRUE;
	[AppDelegate instance].window.rootViewController = tutorial;
}

- (IBAction) login:(id) sender {
	if([SNFModel sharedInstance].loggedInUser) {
		SNFUserService * service = [[SNFUserService alloc] init];
		[service logoutWithCompletion:^(NSError *error) {
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			} else {
				[SNFModel sharedInstance].loggedInUser = nil;
			}
		}];
	} else {
		SNFLogin * login = [[SNFLogin alloc] initWithSourceView:self.loginButton sourceRect:CGRectZero contentSize:CGSizeMake(500,420)];
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	}
}

- (IBAction) createAccount:(id) sender {
	SNFCreateAccount * account = [[SNFCreateAccount alloc] initWithSourceView:self.createAccountButton sourceRect:CGRectZero contentSize:CGSizeMake(500,480)];
	[[AppDelegate rootViewController] presentViewController:account animated:TRUE completion:nil];
}

@end
