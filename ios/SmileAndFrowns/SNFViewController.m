
#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"
#import "UIViewControllerStack.h"
#import "NSTimer+Blocks.h"
#import "SNFTutorial.h"
#import "SNFBoardList.h"
#import "SNFMore.h"
#import "SNFInvites.h"

static __weak SNFViewController * _instance;

@interface SNFViewController ()
@property BOOL firstlayout;
@end

@implementation SNFViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	_instance = self;
	self.firstlayout = true;
	self.viewControllerStack.alwaysResizePushedViews = YES;
}

- (void) dealloc {
	_instance = nil;
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
		[self insertMenu];
		[self showBoardsAnimated:NO];
	}
}

- (void)insertMenu{
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
	SNFDebug *debug = [[SNFDebug alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:debug animated:YES];
}

- (void) showBoardsAnimated:(BOOL) animated {
	SNFBoardList * boardsList = [[SNFBoardList alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:boardsList animated:animated];
}

- (void)showProfile{
	SNFUserProfile *profile = [[SNFUserProfile alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:profile animated:YES];
	[profile loadAuthedUser];
}

- (void)showMore{
	SNFMore *more = [[SNFMore alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:more animated:YES];
}

- (void)debugViewControllerIsDone:(APDDebugViewController *)debugViewController{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showInvitesAnimated:(BOOL) animated; {
	SNFInvites * invites = [[SNFInvites alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:invites animated:animated];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}




@end
