
#import "SNFFormViewController.h"
#import "UIView+LayoutHelpers.h"
#import "NSTimer+Blocks.h"
#import "SNFViewController.h"

@interface SNFFormViewController ()
@property BOOL firstlayout;
@property BOOL keyboardIsVisible;
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

- (void) startBannerAd {
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return;
	}
	
	self.bannerView = [[SNFADBannerView alloc] initWithAdType:ADAdTypeBanner];
	self.bannerView.delegate = self;
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		//self.formView.backgroundColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:1];
		//self.scrollView.backgroundColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:1];
		self.firstlayout = false;
		self.initialFormHeight = self.formView.height;
		self.formView.width = self.scrollView.width;
		
		if(self.formView.height < self.scrollView.height) {
			self.formView.height = self.scrollView.height;
		}
		
		self.scrollView.contentSize = self.formView.size;
		[self.scrollView addSubview:self.formView];
		
	} else {
		
		if(self.scrollView.height > self.initialFormHeight) {
			self.formView.height = self.scrollView.height;
			self.scrollView.contentSize = self.formView.size;
		}
	}
}

- (void) keyboardWillShow:(NSNotification *) notification {
	self.keyboardIsVisible = TRUE;
	
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	CGFloat bottom = keyboardFrameEnd.size.height;
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		return;
	}
	
	CGFloat screenHeight = [UIScreen mainScreen].bounds.size.height;
	
	if([self.view.superview isKindOfClass:[UIScrollView class]]) {
		
		UIScrollView * containerScrollView = (UIScrollView *)self.view.superview;
		self.superScrollViewHeight = containerScrollView.height;
		
		CGFloat csb = containerScrollView.bottom;
		CGFloat heightDiff = screenHeight - csb;
		CGFloat newBottom = heightDiff - bottom;
		if(newBottom < 0) {
			newBottom *= -1;
		}
		
		containerScrollView.height -= newBottom;
		
	} else {
		
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
	
	if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
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
	if(self.keyboardIsVisible) {
		return;
	}
	if(self.scrollViewBottom.constant > banner.height) {
		self.scrollViewBottom.constant -= banner.height;
	}
}

@end
