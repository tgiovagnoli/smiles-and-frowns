#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"
#import "UIViewControllerStack.h"
#import "NSTimer+Blocks.h"

static SNFViewController *_rootViewController;

@implementation SNFViewController

- (id)init{
	self = [super init];
	NSAssert(_rootViewController == nil, @"Can only have 1 instance of SNFViewController");
	_rootViewController = self;
	return self;
}


+ (SNFViewController *)rootViewController{
	return _rootViewController;
}

- (void)viewDidLoad{
	[super viewDidLoad];
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

- (void)showDebug{
	SNFDebug *debug = [[SNFDebug alloc] init];
	[self.viewControllerStack eraseStackAndPushViewController:debug animated:NO];
}

- (void)showBoards{
	[self.viewControllerStack eraseStack];
}

- (void)showProfile{
	[self.viewControllerStack eraseStack];
}

- (void)showMore{
	[self.viewControllerStack eraseStack];
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
