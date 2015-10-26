#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"

#import "NSTimer+Blocks.h"

@implementation SNFViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[NSTimer scheduledTimerWithTimeInterval:0.25 block:^{
		[self showDebug];
	} repeats:NO];
}

- (void)showDebug{
	SNFDebug *debug = [[SNFDebug alloc] init];
	debug.delegate = self;
	[self presentViewController:debug animated:YES completion:^{}];
}

- (void)debugViewControllerIsDone:(APDDebugViewController *)debugViewController{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}


- (IBAction)test:(id)sender{
	[self showDebug];
}

@end
