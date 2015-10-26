
#import "ViewController.h"

@interface ViewController ()
@property ResourcesPreloader * preloader;
@end

@implementation ViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, TRUE);
	NSURL * appSupport = [NSURL fileURLWithPath:paths[0]];
	NSURL * zip = [appSupport URLByAppendingPathComponent:@"data.zip"];
	
	if([ResourcesPreloader canRestorePreloaderForLocalZipFile:zip]) {
		self.preloader = [ResourcesPreloader resourcePreloaderForLocalZipURL:zip];
	} else {
		self.preloader = [[ResourcesPreloader alloc] init];
		self.preloader.localZipURL = zip;
		self.preloader.remoteZipURL = [NSURL URLWithString:@"http://emc-cms.apptitude-digital.com/static/published-data-dev.zip"];
		self.preloader.chilkatKey = @"APPTIT.CB10916_f4YnRKzL6g2O";
	}
	
	self.preloader.delegate = self;
}

- (void) resourcesPreloader:(ResourcesPreloader *)preloader progress:(float)progress {
	NSLog(@"preloader progress: %f",progress);
}

- (void) resourcesPreloaderCompleted:(ResourcesPreloader *)preloader {
	NSLog(@"preloader finished");
}

- (void) resourcesPreloaderFailed:(ResourcesPreloader *)preloader {
	NSLog(@"preloader failed");
}

- (IBAction) resume:(id)sender {
	[self.preloader resume];
}

- (IBAction) stop:(id)sender {
	[self.preloader stop];
}

- (IBAction) cancel:(id)sender {
	[self.preloader cancel];
}

@end
