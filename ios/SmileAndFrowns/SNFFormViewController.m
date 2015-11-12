
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "NSTimer+Blocks.h"
#import "SNFViewController.h"
#import "IAPHelper.h"

@interface SNFFormViewController ()
@property BOOL firstlayout;
@property BOOL keyboardIsVisible;
@property CGFloat superScrollViewHeight;
@end

@implementation SNFFormViewController

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	self.initialFormHeight = self.formView.height;
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) startBannerAd {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return;
	}
	
	if(![[IAPHelper defaultHelper] hasPurchasedNonConsumableNamed:@"RemoveAds"]) {
		self.bannerView = [[SNFADBannerView alloc] initWithAdType:ADAdTypeBanner];
		self.bannerView.delegate = self;
	}
}

- (CGFloat) keyboardBottom:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	CGFloat bottom = keyboardFrameEnd.size.height;
	return bottom;
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		
		/* first ever layout, make formView a subview of scroll view, resize it, set contentSize */
		
		self.firstlayout = false;
		self.formView.width = self.scrollView.width;
		
		//if form view is shorter than scroll view, make it taller.
		if(self.formView.height < self.scrollView.height) {
			self.formView.height = self.scrollView.height;
		}
		
		//sets initial content size based on form view.
		self.scrollView.contentSize = self.formView.size;
		[self.scrollView addSubview:self.formView];
		
		//adjusts top margin for modals on ipad
		if(self.topMargin && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			self.topMargin.constant = 10;
		}
		
	} else {
		
		//resize form view if the scroll view is taller.
		if(self.scrollView.height > self.initialFormHeight) {
			self.formView.height = self.scrollView.height;
			self.scrollView.contentSize = self.formView.size;
		}
		
		//if view is on view controller stack, the outer scroll view handles scrolling.
		if([self.view.superview isKindOfClass:[UIViewControllerStack class]]) {
			self.scrollView.scrollEnabled = FALSE;
		}
	}
}

- (void) keyboardWillShow:(NSNotification *) notification {
	self.keyboardIsVisible = TRUE;
	
	CGFloat bottom = [self keyboardBottom:notification];
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	//self.scrollView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.4];
	//self.formView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:.4];
	
	//if the superview is a UIViewControllerStack, adjust the outer scroll view (the view stack is a scroll view)
	if([self.view.superview isKindOfClass:[UIViewControllerStack class]]) {
		
		UIScrollView * containerScrollView = (UIScrollView *)self.view.superview;
		self.superScrollViewHeight = containerScrollView.height;
		
		CGFloat csb = containerScrollView.bottom;
		CGFloat heightDiff = screenHeight - csb;
		CGFloat newBottom = bottom - heightDiff;
		if(newBottom < 0) {
			newBottom *= -1;
		}
		
		containerScrollView.height -= newBottom;
		
	//otherwise we're running modally.
	} else {
		
		//Modals on ipad don't need any adjustments.
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			return;
		}
		
		CGFloat csb = self.scrollView.bottom;
		CGFloat heightDiff = screenHeight - csb;
		CGFloat newBottom = bottom - heightDiff;
		
		if(self.bannerView.superview) {
			newBottom += self.bannerView.height;
		}
		
		self.scrollViewBottom.constant = newBottom;
		
		[NSTimer scheduledTimerWithTimeInterval:.02 block:^{
			self.formView.height = self.initialFormHeight;
			self.scrollView.contentSize = CGSizeMake(self.formView.width, self.initialFormHeight);
		} repeats:FALSE];
		
	}
}

- (void) keyboardWillHide:(NSNotification *) notification {
	self.keyboardIsVisible = FALSE;
	
	//if the superview is a UIViewControllerStack adjust that view instead
	if([self.view.superview isKindOfClass:[UIViewControllerStack class]]) {
		
		UIScrollView * containerScrollView = (UIScrollView *)self.view.superview;
		if(self.superScrollViewHeight > 0) {
			containerScrollView.height = self.superScrollViewHeight;
		}
		
	//otherwise we're running modally.
	} else {
		
		//Modals on ipad don't need any adjustments..
		if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
			return;
		}
		
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
	if(self.keyboardIsVisible) {
		return;
	}
	if(self.scrollViewBottom.constant > banner.height) {
		self.scrollViewBottom.constant -= banner.height;
	}
}

@end
