
#import "SNFChildEdit.h"
#import "SNFModel.h"
#import "SNFSyncService.h"
#import "UIImage+Additions.h"
#import "UIImageView+NSURLCache.h"
#import "SNFUserService.h"
#import "AppDelegate.h"
#import "UIViewController+Alerts.h"

@implementation SNFChildEdit

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_genderPicker = [[SNFValuePicker alloc] init];
	_genderPicker.tag = SNFChildEditSelectionTypeGender;
	_genderPicker.delegate = self;
	_genderPicker.values = [SNFUser genderSelections];
	
	_agePicker = [[SNFValuePicker alloc] init];
	_agePicker.tag = SNFChildEditSelectionTypeAge;
	_agePicker.delegate = self;
	_agePicker.values = [SNFUser ageSelections];
	
	self.profileImageView.layer.cornerRadius = self.profileImageView.width/2;
	self.profileImageView.layer.borderColor = [[UIColor blackColor] CGColor];
	self.profileImageView.layer.borderWidth = 2;
	self.profileImageView.layer.masksToBounds = TRUE;
	
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onUserProfile:)];
	[self.profileImageView addGestureRecognizer:gr];
	
	[self updateUI];
}

- (void)setChildUser:(SNFUser *)childUser{
	_childUser = childUser;
	[self updateUI];
}

- (void)updateUI{
	if(!_childUser){
		return;
	}
	self.firstNameField.text = self.childUser.first_name;
	self.lastNameField.text = self.childUser.last_name;
	self.ageField.text = [NSString stringWithFormat:@"%ld", self.childUser.age.integerValue];
	if([self.childUser.gender isEqualToString:SNFUserGenderMale]){
		self.genderField.text = @"Male";
	}else if([self.childUser.gender isEqualToString:SNFUserGenderFemale]){
		self.genderField.text = @"Female";
	}else{
		self.genderField.text = @"";
	}
	
	[self updateProfileImage];
}

- (void) updateProfileImage {
	if(_userSelectedImage) {
		
		self.profileImageView.image = _userSelectedImage;
		
	} else if(self.childUser.image) {
		
		NSURL * url = [NSURL URLWithString:self.childUser.image];
		[self.profileImageView setImageWithDefaultAuthBasicForURL:url withCompletion:^(NSError *error, UIImage *image) {
			if(error) {
				[self setImageByGender];
			}
		}];
		
	} else {
		
		[self setImageByGender];
		
	}
}

- (void) setImageByGender {
	if([self.childUser.gender isEqualToString:SNFUserGenderFemale]) {
		
		self.profileImageView.image = [UIImage imageNamed:@"female"];
		
	} else {
		
		self.profileImageView.image = [UIImage imageNamed:@"male"];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (void)onUserProfile:(UITapGestureRecognizer *)sender{
	UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	
	UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
	_userSelectedImage = [image imageCroppedFromSize:CGSizeMake(300,300)];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		SNFUserService * service = [[SNFUserService alloc] init];
		[service updateUserProfileImageWithUsername:self.childUser.username image:_userSelectedImage withCompletion:^(NSError *error, SNFUser * user) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"OK" message:error.localizedDescription completion:nil];
				return;
			}
			
			self.childUser = user;
			[self updateProfileImage];
			
		}];
		
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)updateGenderWithValue:(NSString *)value{
	if([value isEqualToString:[_genderPicker.values firstObject]]){
		self.genderField.text = @"";
	}else{
		self.genderField.text = value;
	}
	[self updateProfileImage];
}

- (void)updateAgeWithValue:(NSString *)value{
	self.ageField.text = value;
}

- (IBAction)onEditGender:(UIButton *)sender{
	[self.view addSubview:_genderPicker.view];
	[_genderPicker.view matchFrameSizeOfView:self.view];
	_genderPicker.selectedValue = self.genderField.text;
}

- (IBAction)onEditAge:(UIButton *)sender{
	[self.view addSubview:_agePicker.view];
	[_agePicker.view matchFrameSizeOfView:self.view];
	_agePicker.selectedValue = self.ageField.text;
}

- (void)valuePicker:(SNFValuePicker *)valuePicker changedValue:(NSString *)value{
	switch ((SNFChildEditSelectionType)valuePicker.tag) {
		case SNFChildEditSelectionTypeAge:
			[self updateAgeWithValue:value];
			break;
		case SNFChildEditSelectionTypeGender:
			[self updateGenderWithValue:value];
			break;
	}
}

- (void)valuePickerFinished:(SNFValuePicker *)valuePicker{
	[valuePicker.view removeFromSuperview];
}

- (IBAction)onSave:(UIButton *)sender{
	self.childUser.first_name = self.firstNameField.text;
	self.childUser.last_name = self.lastNameField.text;
	self.childUser.gender = [self.genderField.text lowercaseString];
	self.childUser.age = [NSNumber numberWithInteger:[self.ageField.text integerValue]];
	[self.childUser updateUserRolesForSyncWithContext:[SNFModel sharedInstance].managedObjectContext];
//	if(_userSelectedImage){
//		[self.childUser updateProfileImage:_userSelectedImage];
//	}
	[[SNFSyncService instance] saveContext];
	if(self.delegate) {
		[self.delegate childEdit:self editedChild:self.childUser];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onCancel:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childEditCancelled:self];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
