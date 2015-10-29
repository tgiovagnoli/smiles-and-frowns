
#import "SNFTutorial.h"
#import "UIView+LayoutHelpers.h"

@interface SNFTutorial ()
@end

@implementation SNFTutorial

- (void) viewDidLoad {
	[super viewDidLoad];
	
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

@end
