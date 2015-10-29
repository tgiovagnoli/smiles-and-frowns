
#import "SNFUserProfile.h"
#import "SNFModel.h"

@implementation SNFUserProfile


- (void)loadAuthedUser{
	if([SNFModel sharedInstance].loggedInUser){
		self.user = [SNFModel sharedInstance].loggedInUser;
	}else{
		SNFUserService *userService = [[SNFUserService alloc] init];
		[userService authedUserInfoWithCompletion:^(NSError *error, SNFUser *user) {
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
}

- (void)updateFieldsWithUserInfo{
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

@end
