
#import "SNFPasswordReset.h"
#import "AppDelegate.h"
#import "SNFUserService.h"
#import "UIView+LayoutHelpers.h"

@interface SNFPasswordReset ()
@property BOOL firstlayout;
@end

@implementation SNFPasswordReset

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
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
}

- (void) keyboardWillHide:(NSNotification *) notification {
	self.scrollViewBottom.constant = 0;
}

- (IBAction) resetPassword:(id)sender {
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	SNFUserService * service = [[SNFUserService alloc] init];
	
	[service resetPasswordForEmail:self.email.text andCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Check your email for a new password" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alert animated:TRUE completion:nil];
		
	}];
	
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
