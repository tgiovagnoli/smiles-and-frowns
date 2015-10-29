
#import "SNFTutorial.h"
#import "UIView+LayoutHelpers.h"
#import "AppDelegate.h"

@interface SNFTutorial ()
@end

@implementation SNFTutorial

- (void) viewDidLoad {
	[super viewDidLoad];
	
	
}

static bool firstlayout = false;
- (void) viewDidLayoutSubviews {
	
	if(firstlayout) {
		return;
	}
	
	firstlayout = true;
	
	NSArray * views = [self.views sortedArrayUsingComparator:^NSComparisonResult(UIView *  obj1, UIView * obj2) {
		if(obj1.tag > obj2.tag) {
			return NSOrderedAscending;
		} else if(obj1.tag < obj2.tag) {
			return NSOrderedAscending;
		}
		return NSOrderedSame;
	}];
	
	float x = 0;
	
	for(UIView * view in views) {
		view.frame = self.scrollView.bounds;
		view.x = x;
		[self.scrollView addSubview:view];
		x += view.width;
	}
	
	self.scrollView.contentSize = CGSizeMake(views.count * self.scrollView.width, self.scrollView.height);
}

+ (BOOL) hasSeenTutorial; {
	return FALSE;
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"HasSeenTutorial"];
}

- (IBAction) getStarted:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"HasSeenTutorial"];
	[[AppDelegate instance] finishTutorial];
}

@end
