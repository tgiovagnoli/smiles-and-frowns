#import "SNFChildEdit.h"
#import "SNFModel.h"
#import "SNFSyncService.h"

@implementation SNFChildEdit

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_genderPicker = [[SNFValuePicker alloc] init];
	_genderPicker.tag = SNFChildEditSelectionTypeGender;
	_genderPicker.delegate = self;
	_genderPicker.values = @[@"---------", @"Male", @"Female"];
	
	_agePicker = [[SNFValuePicker alloc] init];
	_agePicker.tag = SNFChildEditSelectionTypeAge;
	_agePicker.delegate = self;
	NSMutableArray *ages = [[NSMutableArray alloc] init];
	for(NSInteger i=SNFUserAgeMin; i<SNFUserAgeMax; i++){
		[ages addObject:[NSString stringWithFormat:@"%d", i]];
	}
	_agePicker.values = ages;
	
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
	self.ageField.text = [NSString stringWithFormat:@"%d", self.childUser.age.integerValue];
	if([self.childUser.gender isEqualToString:SNFUserGenderMale]){
		self.genderField.text = @"Male";
	}else if([self.childUser.gender isEqualToString:SNFUserGenderFemale]){
		self.genderField.text = @"Female";
	}else{
		self.genderField.text = @"";
	}
	[self updateProfileImage];
}

- (void)updateProfileImage{
	UIImage *childImage = [self.childUser localImage];
	if(_userSelectedImage){
		self.profileImageView.image = _userSelectedImage;
	}else if(childImage){
		self.profileImageView.image = childImage;
	}else if([self.childUser.gender isEqualToString:SNFUserGenderFemale]){
		self.profileImageView.image = [UIImage imageNamed:@"female"];
	}else{
		self.profileImageView.image = [UIImage imageNamed:@"male"];
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (void)onUserProfile:(UITapGestureRecognizer *)sender{
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	_userSelectedImage = [info objectForKey:UIImagePickerControllerEditedImage];
	[self updateProfileImage];
	[self dismissViewControllerAnimated:YES completion:^{}];
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
	if(_userSelectedImage){
		[self.childUser updateProfileImage:_userSelectedImage];
	}
	[[SNFSyncService instance] saveContext];
	if(self.delegate){
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
