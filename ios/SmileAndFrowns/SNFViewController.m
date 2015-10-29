
#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"
#import "UIViewControllerStack.h"
#import "NSTimer+Blocks.h"
#import "SNFTutorial.h"
#import "SNFBoardList.h"
#import "SNFMore.h"

static SNFViewController * _instance;

@implementation SNFViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	_instance = self;
	self.viewControllerStack.alwaysResizePushedViews = YES;
	[NSTimer scheduledTimerWithTimeInterval:0.25 block:^{
		[self insertMenu];
	} repeats:NO];
}

- (void)insertMenu{
	self.tabMenu = [[SNFTabMenu alloc] init];
	[self.tabMenuContainer addSubview:self.tabMenu.view];
	self.tabMenu.view.width = self.tabMenuContainer.width;
	self.tabMenu.view.height = self.tabMenuContainer.height;
	self.tabMenu.view.alpha = 0.0;
	[UIView animateWithDuration:0.1 animations:^{
		self.tabMenu.view.alpha = 1.0;
	}];
}

+ (SNFViewController *) instance {
	return _instance;
}

- (void) showTutorial {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
	[self.view addSubview:tutorial.view];
}

- (void) showDebug {
	SNFDebug *debug = [[SNFDebug alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:debug animated:NO];
}

- (void)showBoards{
	SNFBoardList *boardsList = [[SNFBoardList alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:boardsList animated:NO];
}

- (void)showProfile{
	SNFUserProfile *profile = [[SNFUserProfile alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:profile animated:NO];
	[profile loadAuthedUser];
}

- (void)showMore{
	SNFMore *more = [[SNFMore alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:more animated:NO];
}

- (void)debugViewControllerIsDone:(APDDebugViewController *)debugViewController{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)showInvites{
	[self.viewControllerStack eraseStack];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden {
	return YES;
}




@end
