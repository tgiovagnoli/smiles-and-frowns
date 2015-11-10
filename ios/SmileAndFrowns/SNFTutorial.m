
#import "SNFTutorial.h"
#import "UIView+LayoutHelpers.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFLauncher.h"
#import "SNFViewController.h"
#import "SNFCreateAccount.h"
#import "SNFAcceptInvite.h"

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
	
	if([SNFModel sharedInstance].loggedInUser) {
		
		if(!self.userInitiatedTutorial && [SNFLauncher showAtLaunch]) {
			
			SNFLauncher * launcher = [[SNFLauncher alloc] init];
			[AppDelegate instance].window.rootViewController = launcher;
			
			if([SNFModel sharedInstance].pendingInviteCode) {
				SNFAcceptInvite * accept = [[SNFAcceptInvite alloc] initWithSourceView:launcher.acceptInviteButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
				[[AppDelegate rootViewController] presentViewController:accept animated:TRUE completion:nil];
			}
		
		} else {
			
			SNFViewController * root = [[SNFViewController alloc] init];
			
			if([SNFModel sharedInstance].pendingInviteCode) {
				root.firstTab = SNFTabInvites;
			}
			
			[AppDelegate instance].window.rootViewController = root;
			
			if([SNFModel sharedInstance].pendingInviteCode) {
				SNFAcceptInvite * accept = [[SNFAcceptInvite alloc] initWithSourceView:root.tabMenu.invitesButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
				[[AppDelegate rootViewController] presentViewController:accept animated:TRUE completion:nil];
			}
			
		}
		
	} else {
		
		SNFLauncher * launcher = [[SNFLauncher alloc] init];
		[AppDelegate instance].window.rootViewController = launcher;
		
		if([SNFModel sharedInstance].pendingInviteCode) {
			
			SNFCreateAccount * signup = [[SNFCreateAccount alloc] initWithSourceView:launcher.createAccountButton sourceRect:CGRectZero contentSize:CGSizeMake(500,560)];
			signup.nextViewController = [[SNFAcceptInvite alloc] initWithSourceView:launcher.acceptInviteButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
			[[AppDelegate rootViewController] presentViewController:signup animated:TRUE completion:nil];
			
		}
		
	}
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
