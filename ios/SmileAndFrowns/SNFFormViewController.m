
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "NSTimer+Blocks.h"
#import "SNFViewController.h"

@interface SNFFormViewController ()
@property BOOL firstlayout;
@end

@implementation SNFFormViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.formView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.4];
		self.scrollView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.4];
		self.firstlayout = false;
		self.formView.width = self.scrollView.width;
		self.scrollView.contentSize = self.formView.size;
		[self.scrollView addSubview:self.formView];
	}
}

- (CGFloat) scrollViewBottomConstraint:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	CGFloat bottom = keyboardFrameEnd.size.height;
	if([SNFViewController instance]) {
		if([SNFViewController instance].isAdDisplayed) {
			bottom -= [SNFViewController instance].bannerView.height;
		}
	}
	return bottom;
}

- (void) keyboardWillShow:(NSNotification *) notification {
	CGFloat bottom = [self scrollViewBottomConstraint:notification];
	self.scrollViewBottom.constant = bottom;
}

- (void) keyboardWillHide:(NSNotification *) notification {
	self.scrollViewBottom.constant = 0;
}

@end
