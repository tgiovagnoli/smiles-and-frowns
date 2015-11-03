
#import "SNFUserProfile.h"
#import "SNFViewController.h"
#import "SNFModel.h"
#import "AppDelegate.h"
#import "UIAlertAction+Additions.h"
#import "SNFLauncher.h"
#import "NSTimer+Blocks.h"
#import "SNFUserService.h"

@interface SNFUserProfile ()
@property BOOL isUpdatingPassword;
@property NSArray * genders;
@property SNFUserService * service;
@end

@implementation SNFUserProfile

- (void) viewDidLoad {
	[super viewDidLoad];
	self.genders = @[@"--------",@"Male",@"Female"];
	self.pickerView.delegate = self;
	self.pickerView.dataSource = self;
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
	[self loadAuthedUser];
}

- (IBAction) onGender:(id)sender {
	[self.view endEditing:TRUE];
	
	self.pickerviewContainer.frame = self.view.bounds;
	[self.pickerView reloadAllComponents];
	
	self.pickerviewContainer.alpha = 0;
	[self.view addSubview:self.pickerviewContainer];
	
	UIViewAnimationOptions options = UIViewAnimationOptionCurveEaseInOut;
	[UIView animateWithDuration:.25 delay:0 options:options animations:^{
		self.pickerviewContainer.alpha = 1;
	} completion:^(BOOL finished) {
		
	}];
}

- (NSInteger) numberOfComponentsInPickerView:(UIPickerView *) pickerView {
	return 1;
}

- (NSInteger) pickerView:(UIPickerView *) pickerView numberOfRowsInComponent:(NSInteger) component {
	return self.genders.count;
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger) row forComponent:(NSInteger) component {
	return [self.genders objectAtIndex:row];
}

- (void) pickerView:(UIPickerView *) pickerView didSelectRow:(NSInteger) row inComponent:(NSInteger) component {
	if(row == 0) {
		return;
	}
	self.gender.text = [self.genders objectAtIndex:row];
}

- (IBAction) closePicker:(id)sender {
	[self.pickerviewContainer removeFromSuperview];
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
}

- (IBAction) update:(id) sender {
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
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:msg preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:TRUE completion:nil];
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
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		self.passwordField.text = @"";
		self.passwordConfirmField.text = @"";
		self.user = user;
		
		UIAlertController * alert = nil;
		if(self.isUpdatingPassword) {
			alert = [UIAlertController alertControllerWithTitle:@"Profile Updated" message:@"Your password was updated" preferredStyle:UIAlertControllerStyleAlert];
		} else {
			alert = [UIAlertController alertControllerWithTitle:@"Profile Updated" message:@"Your profile was updated" preferredStyle:UIAlertControllerStyleAlert];
		}
		[alert addAction:[UIAlertAction OKAction]];
		[self presentViewController:alert animated:TRUE completion:nil];
	}];
}

@end
