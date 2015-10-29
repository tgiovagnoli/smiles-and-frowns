#import "SNFUserProfile.h"
#import "SNFModel.h"

@implementation SNFUserProfile


- (void)viewDidLoad{
	[self updateFieldsWithUserInfo];
}

- (void)loadAuthedUser{
	if([SNFModel sharedInstance].loggedInUser){
		self.user = [SNFModel sharedInstance].loggedInUser;
	}else{
		SNFUserService *userService = [[SNFUserService alloc] init];
		[MBProgressHUD showHUDAddedTo:self.view animated:YES];
		[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
			[MBProgressHUD hideHUDForView:self.view animated:YES];
			if(!error && user){
				self.user = user;
			}else{
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"You must be logged in to edit your profile.  Would you like to login now?" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
				}]];
				[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
					
				}]];
			}
		}];
	}
}

- (void)showLoggedInBlocker{
	
}

- (void)setUser:(SNFUser *)user{
	_user = user;
	[self updateFieldsWithUserInfo];
}

- (void)updateFieldsWithUserInfo{
	self.firstNameField.text = self.user.first_name;
	self.lastNameField.text = self.user.last_name;
	self.emailField.text = self.user.email;
	self.passwordField.text = @"32764789326498326";
	self.passwordConfirmField.text = @"312764789326498321";
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

@end
