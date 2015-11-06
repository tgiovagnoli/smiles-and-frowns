
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
	
	if([SNFModel sharedInstance].loggedInUser) {
		[self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
		[self.createAccountButton setVisible:FALSE];
	}
	
	[[SNFModel sharedInstance] addObserver:self forKeyPath:@"loggedInUser" options:NSKeyValueObservingOptionNew context:nil];
	
	if([SNFModel sharedInstance].pendingInviteCode) {
		[NSTimer scheduledTimerWithTimeInterval:.3 block:^{
			SNFCreateAccount * create = [[SNFCreateAccount alloc] init];
			create.nextViewController = [[SNFAcceptInvite alloc] init];
			[[AppDelegate rootViewController] presentViewController:create animated:TRUE completion:nil];
		} repeats:FALSE];
	}
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
	}
}

- (void) dealloc {
	[[SNFModel sharedInstance] removeObserver:self forKeyPath:@"loggedInUser"];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
	if([keyPath isEqualToString:@"loggedInUser"] && [SNFModel sharedInstance].loggedInUser) {
		[self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
		[self.createAccountButton setVisible:FALSE];
	} else {
		[self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
		[self.createAccountButton setVisible:TRUE];
	}
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
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	} else {
		[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
	}
}

- (IBAction) viewTutorial:(id)sender {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
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
		
		SNFLogin * login = [[SNFLogin alloc] init];
		login.modalPresentationStyle = UIModalPresentationPopover;
		login.popoverPresentationController.sourceView = self.loginButton;
		login.popoverPresentationController.sourceRect = CGRectMake(self.loginButton.width/2,0,10,10);
		
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	}
}

- (IBAction) createAccount:(id) sender {
	
	SNFCreateAccount * account = [[SNFCreateAccount alloc] init];
	account.modalPresentationStyle = UIModalPresentationPopover;
	account.popoverPresentationController.sourceView = self.createAccountButton;
	account.popoverPresentationController.sourceRect = CGRectMake(self.createAccountButton.width/2,0,10,10);
	
	[[AppDelegate rootViewController] presentViewController:account animated:TRUE completion:nil];
}

@end
