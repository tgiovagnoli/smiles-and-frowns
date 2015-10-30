
#import "SNFAcceptInvite.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFUserService.h"
#import "SNFViewController.h"

@interface SNFAcceptInvite ()
@property BOOL firstlayout;
@property SNFUserService * service;
@end

@implementation SNFAcceptInvite

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	if([SNFModel sharedInstance].pendingInviteCode) {
		self.inviteCodeField.text = [SNFModel sharedInstance].pendingInviteCode;
	}
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
		self.formView.frame = self.scrollView.bounds;
		self.scrollView.contentSize = self.scrollView.size;
		[self.scrollView addSubview:self.formView];
	}
}

- (void) keyboardWillShow:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	if(self.scrollViewBottom.constant == keyboardFrameEnd.size.height) {
		return;
	}
	self.formView.height -= 380;
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.scrollViewBottom.constant == 0) {
		return;
	}
	self.scrollViewBottom.constant = 0;
	self.formView.height += 380;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.scrollView.height);
}

- (IBAction) joinBoard:(id) sender {
	self.service = [[SNFUserService alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service acceptInviteCode:self.inviteCodeField.text andCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Invitation Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		[AppDelegate instance].window.rootViewController = [[SNFViewController alloc] init];
		[[SNFViewController instance] showBoardsAnimated:FALSE];
		
	}];
}

- (IBAction) cancel:(id) sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
