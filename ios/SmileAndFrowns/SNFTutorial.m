
#import "SNFTutorial.h"
#import "UIView+LayoutHelpers.h"
#import "AppDelegate.h"

@interface SNFTutorial ()
@property BOOL firstlayout;
@end

@implementation SNFTutorial

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	self.scrollView.pagingEnabled = TRUE;
	self.pageControl.numberOfPages = self.views.count;
	self.scrollView.delegate = self;
}

- (void) viewDidLayoutSubviews {
	
	if(self.firstlayout) {
		self.firstlayout = false;
		
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
}

+ (BOOL) hasSeenTutorial; {
	return [[NSUserDefaults standardUserDefaults] boolForKey:@"HasSeenTutorial"];
}

- (IBAction) getStarted:(id)sender {
	[[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:@"HasSeenTutorial"];
	[[AppDelegate instance] finishTutorial:self.userInitiatedTutorial];
}

- (void) trackPage {
	
}

- (void) scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	if(!decelerate) {
		[self trackPage];
	}
}

- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	NSInteger page = scrollView.contentOffset.x / scrollView.frame.size.width;
	self.pageControl.currentPage = page;
	[self trackPage];
}

- (IBAction) pageControlChange:(id)sender {
	NSInteger page = self.pageControl.currentPage;
	[self.scrollView scrollRectToVisible:CGRectMake(page*self.scrollView.width,0,self.scrollView.width,self.scrollView.height) animated:TRUE];
	[self trackPage];
}

@end
