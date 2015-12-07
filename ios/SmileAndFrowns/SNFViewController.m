
#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"
#import "UIViewControllerStack.h"
#import "NSTimer+Blocks.h"
#import "SNFTutorial.h"
#import "SNFBoardList.h"
#import "SNFMore.h"
#import "SNFInvites.h"
#import "NSLog+Geom.h"
#import "SNFADBannerView.h"
#import "SNFSyncService.h"
#import "AppDelegate.h"
#import "SNFLauncher.h"

static __weak SNFViewController * _instance;

@interface SNFViewController ()
@property BOOL firstlayout;
@property BOOL isKeyboardShown;
@end

@implementation SNFViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	
	_instance = self;
	self.firstlayout = true;
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onKeyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSyncError:) name:SNFSyncServiceError object:nil];
	
	if(![[IAPHelper defaultHelper] hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		self.bannerView = [[SNFADBannerView alloc] initWithAdType:ADAdTypeBanner];
		self.bannerView.delegate = self;
	}
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	_instance = nil;
}

- (void) onKeyboardWillShow:(NSNotification *) npte {
	self.isKeyboardShown = TRUE;
}

- (void) onKeyboardWillHide:(NSNotification *) note {
	self.isKeyboardShown = FALSE;
}

- (BOOL) isAdDisplayed; {
	return !(self.bannerView.superview == nil);
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
		[self insertMenu];
		
		if(self.firstTab == SNFTabBoards || self.firstTab == SNFTabDefault) {
			[self showBoardsAnimated:NO];
		}
		
		else if(self.firstTab == SNFTabInvites) {
			[self showInvitesAnimated:NO];
		}
		
		else if(self.firstTab == SNFTabProfile) {
			[self showProfile];
		}
		
		else if(self.firstTab == SNFTabMore) {
			[self showMore];
		}
		
		else if(self.firstTab == SNFTabDebug) {
			[self showDebug];
		}
	}
}

- (void) bannerViewDidLoadAd:(ADBannerView *) banner {
	CGRect f = banner.frame;
	f.origin.y = self.view.height - banner.height;
	self.bannerView.frame = f;
	self.tabMenuContainerBottom.constant = banner.height;
	[self.view addSubview:self.bannerView];
	
	[NSTimer scheduledTimerWithTimeInterval:.1 block:^{
		UIViewController * controller = self.viewControllerStack.currentViewController;
		if([controller isKindOfClass:[SNFFormViewController class]]) {
			SNFFormViewController * formController = (SNFFormViewController *)controller;
			[formController invalidateForScrolling];
		}
	} repeats:FALSE];
	
}

- (void) bannerView:(ADBannerView *) banner didFailToReceiveAdWithError:(NSError *) error {
	[self.bannerView removeFromSuperview];
	self.tabMenuContainerBottom.constant = 0;
	
	[NSTimer scheduledTimerWithTimeInterval:.1 block:^{
		UIViewController * controller = self.viewControllerStack.currentViewController;
		if([controller isKindOfClass:[SNFFormViewController class]]) {
			SNFFormViewController * formController = (SNFFormViewController *)controller;
			[formController invalidateForScrolling];
		}
	} repeats:FALSE];
}

- (void) insertMenu {
	self.tabMenu = [[SNFTabMenu alloc] init];
	[self.tabMenuContainer addSubview:self.tabMenu.view];
	self.tabMenu.view.width = self.tabMenuContainer.width;
	self.tabMenu.view.height = self.tabMenuContainer.height;
	self.tabMenu.view.alpha = 0.0;
	
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:.25 delay:.1 options:options animations:^{
		self.tabMenu.view.alpha = 1.0;
	} completion:^(BOOL finished) {
	}];
}

+ (SNFViewController *) instance {
	return _instance;
}

- (void) showDebug {
	if([[self.viewControllerStack currentViewController] isKindOfClass:[SNFDebug class]]) {
		return;
	}
	SNFDebug *debug = [[SNFDebug alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:debug animated:YES];
}

- (void) showBoardsAnimated:(BOOL) animated {
	if([[self.viewControllerStack currentViewController] isKindOfClass:[SNFBoardList class]]) {
		return;
	}
	SNFBoardList * boardsList = [[SNFBoardList alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:boardsList animated:animated];
	
	[self.tabMenu setActiveSection:SNFTabBoards];
}

- (void)showProfile{
	if([[self.viewControllerStack currentViewController] isKindOfClass:[SNFUserProfile class]]) {
		return;
	}
	SNFUserProfile *profile = [[SNFUserProfile alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:profile animated:YES];
	
	[self.tabMenu setActiveSection:SNFTabProfile];
}

- (void)showMore{
	if([[self.viewControllerStack currentViewController] isKindOfClass:[SNFMore class]]) {
		return;
	}
	SNFMore *more = [[SNFMore alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:more animated:YES];
	
	[self.tabMenu setActiveSection:SNFTabMore];
}

- (void)debugViewControllerIsDone:(APDDebugViewController *)debugViewController{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showInvitesAnimated:(BOOL) animated; {
	if([[self.viewControllerStack currentViewController] isKindOfClass:[SNFInvites class]]) {
		return;
	}
	SNFInvites * invites = [[SNFInvites alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:invites animated:animated];
	
	[self.tabMenu setActiveSection:SNFTabInvites];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}

- (void)onSyncError:(NSNotification *)notification{
	NSError *error = [notification object];
	if([error.domain isEqualToString:SNFErrorDomain]){
		if(error.code == SNFErrorCodeDjangoDebugError){
			APDDjangoErrorViewer *errorViewer = [[APDDjangoErrorViewer alloc] init];
			[[AppDelegate rootViewController] presentViewController:errorViewer animated:YES completion:nil];
			[errorViewer showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"sync"]];
		}else{
			[self showErrorMessage:error.localizedDescription];
		}
	}
}

- (void)showErrorMessage:(NSString *)errorMessage{
	NSLog(@"show error: %@",errorMessage);
	[self displayOKAlertWithTitle:@"Sync Error" message:errorMessage completion:^(UIAlertAction *action) {
		if([errorMessage isEqualToString:@"login required"]) {
			[SNFModel sharedInstance].loggedInUser = nil;
			[AppDelegate instance].window.rootViewController = [[SNFLauncher alloc] init];
		}
	}];
}

@end
