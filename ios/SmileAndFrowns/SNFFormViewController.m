
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "NSTimer+Blocks.h"
#import "SNFViewController.h"

@interface SNFFormViewController ()
@property BOOL firstlayout;
@property CGFloat superScrollViewHeight;
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

- (void) starBannerAd {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return;
	}
	
	self.bannerView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
	self.bannerView.delegate = self;
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		//self.formView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
		//self.scrollView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
		self.firstlayout = false;
		self.initialFormHeight = self.formView.height;
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
	
	NSLog(@"%@",self.view.superview);
	NSLog(@"%@",self.view.superview.superview);
	
	if(self.modalPresentationStyle == UIModalPresentationPopover) {
		NSLog(@"popover");
		return;
	}
	
	CGFloat bottom = [self scrollViewBottomConstraint:notification];
	
	if([self.view.superview isKindOfClass:[UIScrollView class]]) {
		
		UIScrollView * containerScrollView = (UIScrollView *)self.view.superview;
		self.superScrollViewHeight = containerScrollView.height;
		containerScrollView.height -= bottom;
		[NSTimer scheduledTimerWithTimeInterval:.1 block:^{
			self.formView.height = self.initialFormHeight;
		} repeats:FALSE];
	
	} else {
		
		self.scrollViewBottom.constant = bottom;
		[NSTimer scheduledTimerWithTimeInterval:.1 block:^{
			self.formView.height = self.initialFormHeight;
		} repeats:FALSE];
		
	}
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.modalPresentationStyle == UIModalPresentationPopover) {
		NSLog(@"popover");
		return;
	}
	
	if([self.view.superview isKindOfClass:[UIScrollView class]]) {
		UIScrollView * containerScrollView = (UIScrollView *)self.view.superview;
		containerScrollView.height = self.superScrollViewHeight;
	} else {
		if(self.bannerView.superview) {
			self.scrollViewBottom.constant = self.bannerView.height;
		} else {
			self.scrollViewBottom.constant = 0;
		}
	}
}

- (void) bannerViewDidLoadAd:(ADBannerView *)banner {
	[self.view addSubview:banner];
	banner.y = self.view.height - banner.height;
	if(self.scrollViewBottom.constant <= banner.height) {
		self.scrollViewBottom.constant = banner.height;
	}
}

- (void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
	[self.bannerView removeFromSuperview];
	if(self.scrollViewBottom.constant > banner.height) {
		self.scrollViewBottom.constant -= banner.height;
	}
}

@end
