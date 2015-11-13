
#import "SNFUserProfile.h"
#import "SNFViewController.h"
#import "SNFModel.h"
#import "AppDelegate.h"
#import "UIAlertAction+Additions.h"
#import "SNFLauncher.h"
#import "NSTimer+Blocks.h"
#import "SNFUserService.h"
#import "UIViewController+Alerts.h"

@interface SNFUserProfile ()
@property BOOL isUpdatingPassword;
@property SNFUserService * service;
@end

@implementation SNFUserProfile

- (void) viewDidLoad {
	[super viewDidLoad];
	
	_genderPicker = [[SNFValuePicker alloc] init];
	_genderPicker.delegate = self;
	_genderPicker.values = [SNFUser genderSelections];
	
	_agePicker = [[SNFValuePicker alloc] init];
	_agePicker.delegate = self;
	_agePicker.values = [SNFUser ageSelections];
	
	self.firstNameField.delegate = self;
	self.lastNameField.delegate = self;
	self.emailField.delegate = self;
	self.passwordConfirmField.delegate = self;
	self.passwordField.delegate = self;
	self.age.delegate = self;
	
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
	[self.ageOverlay setTitle:@"" forState:UIControlStateNormal];
	[self loadAuthedUser];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (CGFloat) minViewHeightForViewStackController:(UIViewControllerStack *)viewStack isScrollView:(BOOL)isScrollView {
	return self.initialFormHeight + self.scrollView.top;
}

- (void) viewStack:(UIViewControllerStack *) viewStack didResizeViewController:(UIViewController *) viewController {
}

- (IBAction) onGender:(id) sender {
	[self.view endEditing:TRUE];
	[self.view addSubview:_genderPicker.view];
	[_genderPicker.view matchFrameSizeOfView:self.view];
	_genderPicker.view.alpha = 1.0;
	_genderPicker.selectedValue = self.gender.text;
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:.25 delay:0 options:options animations:^{
		_genderPicker.view.alpha = 1;
	} completion:nil];
}

- (IBAction) onAge:(id) sender{
	[self.view endEditing:TRUE];
	[self.view addSubview:_agePicker.view];
	[_agePicker.view matchFrameSizeOfView:self.view];
	_agePicker.view.alpha = 1.0;
	_agePicker.selectedValue = self.age.text;
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:.25 delay:0 options:options animations:^{
		_agePicker.view.alpha = 1;
	} completion:nil];
}

- (void) valuePickerFinished:(SNFValuePicker *) valuePicker {
	[valuePicker.view removeFromSuperview];
}

- (void) valuePicker:(SNFValuePicker *) valuePicker changedValue:(NSString *) value {
	if(valuePicker == _agePicker){
		[self updateAgeWithValue:value];
	}else{
		[self updateGenderWithValue:value];
	}
}

- (void) updateAgeWithValue:(NSString *) value{
	self.age.text = value;
}

- (void) updateGenderWithValue:(NSString *) value{
	if([value isEqualToString:[_genderPicker.values firstObject]]){
		self.gender.text = @"";
	}else{
		self.gender.text = value;
	}
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	[self.view endEditing:TRUE];
	return YES;
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
	
	if([self.user.age integerValue] != 0) {
		self.age.text = [NSString stringWithFormat:@"%@",self.user.age];
	}
	
	if([self.user.gender isEqualToString:@"male"]) {
		self.gender.text = @"Male";
		self.profileImage.image = [UIImage imageNamed:@"Male"];
	} else if([self.user.gender isEqualToString:@"female"]) {
		self.gender.text = @"Female";
		self.profileImage.image = [UIImage imageNamed:@"Female"];
	}
	
	//TODO: update profile image from user
}

- (IBAction) update:(id) sender {
	self.isUpdatingPassword = NO;
	NSMutableDictionary * data = [NSMutableDictionary dictionary];
	data[@"first_name"] = self.firstNameField.text;
	data[@"last_name"] = self.lastNameField.text;
	data[@"email"] = self.emailField.text;
	data[@"password"] = self.passwordField.text;
	data[@"password_confirm"] = self.passwordConfirmField.text;
	data[@"age"] = self.age.text;
	data[@"gender"] = self.gender.text.lowercaseString;
	[self updateUserWithData:data];
}

- (IBAction) updatePassword:(id)sender {
	self.isUpdatingPassword = TRUE;
	
	NSMutableDictionary * data = [NSMutableDictionary dictionary];
	data[@"first_name"] = self.firstNameField.text;
	data[@"last_name"] = self.lastNameField.text;
	data[@"email"] = self.emailField.text;
	data[@"password"] = self.passwordField.text;
	data[@"password_confirm"] = self.passwordConfirmField.text;
	data[@"age"] = self.age.text;
	data[@"gender"] = self.gender.text.lowercaseString;
	
	NSString * msg = nil;
	
	if([self.passwordField.text isEmpty]) {
		msg = @"Password required";
	}
	
	if(!msg && [self.passwordConfirmField.text isEmpty]) {
		msg = @"Password confirm required";
	}
	
	if(!msg && ![self.passwordField.text isEqualToString:self.passwordConfirmField.text]) {
		msg = @"Passwords don't match";
	}
	
	if(msg) {
		[self displayOKAlertWithTitle:@"Form Error" message:msg completion:nil];
		return;
	}
	
	[self updateUserWithData:data];
}

- (void) updateUserWithData:(NSDictionary *) data {
	self.service = [[SNFUserService alloc] init];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.service updateUserWithData:data withCompletion:^(NSError * error, SNFUser * user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		self.passwordField.text = @"";
		self.passwordConfirmField.text = @"";
		self.user = user;
		NSString * msg = nil;
		NSString * title = @"Profile Updated";
		
		if(self.isUpdatingPassword) {
			msg = @"Your password was updated";
		} else {
			msg = @"Your profile was updated";
		}
		
		[self displayOKAlertWithTitle:title message:msg completion:nil];
	}];
}

- (IBAction) onUserProfile:(id)sender {
	UIImagePickerController * picker = [[UIImagePickerController alloc] init];
	picker.delegate = self;
	picker.allowsEditing = YES;
	picker.delegate = self;
	[[AppDelegate rootViewController] presentViewController:picker animated:TRUE completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
	
	UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
	
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		SNFUserService * service = [[SNFUserService alloc] init];
		[service updateUserProfileImageWithUsername:[SNFModel sharedInstance].loggedInUser.username image:image withCompletion:^(NSError *error, SNFUser *user) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			//TODO: sync, if synign waiting for notification and try again
		}];
		
	}];
	
}

- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
