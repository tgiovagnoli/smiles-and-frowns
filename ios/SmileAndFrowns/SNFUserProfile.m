
#import "SNFUserProfile.h"
#import "SNFViewController.h"
#import "SNFModel.h"
#import "AppDelegate.h"
#import "UIAlertAction+Additions.h"
#import "SNFLauncher.h"

@interface SNFUserProfile ()
@property BOOL firstlayout;
@end

@implementation SNFUserProfile

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	[self loadAuthedUser];
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
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
	self.formView.height -= 330;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.scrollViewBottom.constant == 0) {
		return;
	}
	self.scrollViewBottom.constant = 0;
	self.formView.height += 330;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) loadAuthedUser {
	SNFUserService * userService = [[SNFUserService alloc] init];
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
		[MBProgressHUD hideHUDForView:self.view animated:YES];
		if(error) {
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error" message:@"You must be logged in to edit your profile." preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKActionWithCompletion:^(UIAlertAction * action) {
				[SNFModel sharedInstance].loggedInUser = nil;
				[AppDelegate instance].window.rootViewController = [[SNFLauncher alloc] init];
			}]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		self.user = user;
	}];
}

- (void) setUser:(SNFUser *) user {
	_user = user;
	[self updateFieldsWithUserInfo];
}

- (void) updateFieldsWithUserInfo {
	self.firstNameField.text = self.user.first_name;
	self.lastNameField.text = self.user.last_name;
	self.emailField.text = self.user.email;
	self.passwordField.text = @"32764789326498326";
	self.passwordConfirmField.text = @"312764789326498321";
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	return NO;
}

@end
