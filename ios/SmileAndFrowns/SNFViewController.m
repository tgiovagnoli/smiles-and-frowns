
#import "SNFViewController.h"
#import "SNFBoard.h"
#import "SNFModel.h"
#import "NSTimer+Blocks.h"
#import "SNFTutorial.h"

static SNFViewController * _instance;

@implementation SNFViewController

+ (SNFViewController *) instance {
	return _instance;
}

- (void) viewDidLoad {
	[super viewDidLoad];
	
	_instance = self;
}

- (void) showDebug {
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
