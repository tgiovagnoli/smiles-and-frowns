#import "SNFChildEdit.h"
#import "SNFModel.h"

@implementation SNFChildEdit

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_genderValues = @[@"---------", @"Male", @"Female"];
	NSMutableArray *ages = [[NSMutableArray alloc] init];
	for(NSInteger i=0; i<100; i++){
		[ages addObject:[NSString stringWithFormat:@"%lu", i]];
	}
	_ageValues = [NSArray arrayWithArray:ages];
	
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
	self.ageField.text = [NSString stringWithFormat:@"%lu", self.childUser.age.integerValue];
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	switch (_selectionType) {
		case SNFChildEditSelectionTypeAge:
			return _ageValues.count;
			break;
		case SNFChildEditSelectionTypeGender:
			return _genderValues.count;
			break;
	}
	return 0;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	switch (_selectionType) {
		case SNFChildEditSelectionTypeAge:
			return [_ageValues objectAtIndex:row];
			break;
		case SNFChildEditSelectionTypeGender:
			return [_genderValues objectAtIndex:row];
			break;
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	switch (_selectionType) {
		case SNFChildEditSelectionTypeAge:
			[self updateAgeWithValue:[_ageValues objectAtIndex:row]];
			break;
		case SNFChildEditSelectionTypeGender:
			[self updateGenderWithValue:[_genderValues objectAtIndex:row]];
			break;
	}
}

- (void)updateGenderWithValue:(NSString *)value{
	if([value isEqualToString:[_genderValues firstObject]]){
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
	_selectionType = SNFChildEditSelectionTypeGender;
	[self.pickerView reloadAllComponents];
	for(NSInteger i=0; i<_genderValues.count; i++){
		if([[_genderValues objectAtIndex:i] isEqualToString:self.genderField.text]){
			[self.pickerView selectRow:i inComponent:0 animated:NO];
		}
	}
	[self.selectionContainer matchFrameSizeOfView:self.view];
	[self.view addSubview:self.selectionContainer];
}

- (IBAction)onEditAge:(UIButton *)sender{
	_selectionType = SNFChildEditSelectionTypeAge;
	[self.pickerView reloadAllComponents];
	for(NSInteger i=0; i<_ageValues.count; i++){
		if([[_ageValues objectAtIndex:i] isEqualToString:self.ageField.text]){
			[self.pickerView selectRow:i inComponent:0 animated:NO];
		}
	}
	[self.selectionContainer matchFrameSizeOfView:self.view];
	[self.view addSubview:self.selectionContainer];
}

- (IBAction)selectionDone:(UIButton *)sender{
	[self.selectionContainer removeFromSuperview];
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
