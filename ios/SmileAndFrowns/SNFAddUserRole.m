
#import "SNFAddUserRole.h"
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFUserService.h"
#import "MBProgressHUD.h"
#import "UIAlertAction+Additions.h"

@implementation SNFAddUserRole


- (void)setBoard:(SNFBoard *)board andCompletion:(SNFAddUserRoleCallback)completion{
	_completion = completion;
	_board = board;
	
	_pickerValues = @[
					  @{@"": @"-----------"},
					  @{@"male": @"Male"},
					  @{@"female": @"Female"},
					  ];
	
	[self.genderPicker reloadAllComponents];
}

- (void)viewDidLayoutSubviews{
	if(!_hasLaidOut){
		UIButton *genderOverlay = [[UIButton alloc] initWithFrame:self.genderField.frame];
		[genderOverlay addTarget:self action:@selector(openGenderPicker:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:genderOverlay];
		_hasLaidOut = YES;
	}
}

- (IBAction)onAddRole:(UIButton *)sender{
	switch (self.roleControl.selectedSegmentIndex) {
		case SNFUserRoleAddChild:
			[self addChildRole];
			break;
		case SNFUserRoleAddGuardian:
			[self addGuardianRole];
			break;
		case SNFUserRoleAddParent:
			[self addParentRole];
			break;
	}
}

- (IBAction)onRoleValueChanged:(UISegmentedControl *)sender{
	switch (self.roleControl.selectedSegmentIndex) {
		case SNFUserRoleAddChild:
			[self.emailField setPlaceholder:@"Email (Optional)"];
			break;
		case SNFUserRoleAddGuardian:
			[self.emailField setPlaceholder:@"Email"];
			break;
		case SNFUserRoleAddParent:
			[self.emailField setPlaceholder:@"Email"];
			break;
	}
}

- (IBAction)onCancel:(UIButton *)sender{
	_completion(nil, nil);
}

- (IBAction)onAddFromContacts:(UIButton *)sender{
	CNContactPickerViewController  *picker = [[CNContactPickerViewController  alloc] init];
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:^{}];
}

- (void)contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact{
	[self dismissViewControllerAnimated:YES completion:^{}];
	if(contact.emailAddresses.count > 0){
		self.emailField.text = [contact.emailAddresses firstObject].value;
	}else{
		self.emailField.text = @"";
	}
	
	if(contact.givenName){
		self.firstNameField.text = contact.givenName;
	}else{
		self.firstNameField.text = @"";
	}
	
	if(contact.familyName){
		self.lastNameField.text = contact.familyName;
	}else{
		self.lastNameField.text = @"";
	}
	
	if(contact.birthday){
		NSDate *bday = [contact.birthday date];
		NSDate *now = [NSDate date];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		// pass as many or as little units as you like here, separated by pipes
		NSUInteger units = NSCalendarUnitYear;
		NSDateComponents *components = [gregorian components:units fromDate:bday toDate:now options:0];
		NSInteger years = [components year];
		self.ageField.text = [NSString stringWithFormat:@"%ld", (long)years];
	}else{
		self.ageField.text = @"";
	}
}

- (void)contactPickerDidCancel:(CNContactPickerViewController *)picker{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void)addChildRole{
	if(![self validBoard]){
		return;
	}
	if(![self validName]){
		return;
	}
	[self createRole];
}

- (void)addParentRole{
	if(![self validBoard]){
		return;
	}
	if(![self validEmail]){
		return;
	}
	if(![self validName]){
		return;
	}
	[self createInvite];
}

- (void)addGuardianRole{
	if(![self validBoard]){
		return;
	}
	if(![self validEmail]){
		return;
	}
	if(![self validName]){
		return;
	}
	[self createInvite];
}

- (void)createRole{
	NSNumber *age = [NSNumber numberWithInteger:[self.ageField.text integerValue]];
	
	NSString *gender = @"";
	if(![self.genderField.text isEmpty]){
		gender = [self.genderField.text lowercaseString];
	}
	NSDictionary *info = @{
						   @"role": @"child",
						   @"board": @{
								   @"uuid": self.board.uuid
								   },
						   @"user": @{
								   @"first_name": self.firstNameField.text,
								   @"last_name": self.lastNameField.text,
								   @"email": self.emailField.text,
								   @"age": age,
								   @"gender": gender
								   }
						   };
	SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:info withContext:[SNFModel sharedInstance].managedObjectContext];
	_completion(nil, userRole);
}

- (void)createInvite{
	NSString *role = SNFUserRoleGuardian;
	if(self.roleControl.selectedSegmentIndex == SNFUserRoleAddParent){
		role = SNFUserRoleParent;
	}
	
	NSDictionary *userRoleData = @{
								   @"role": role,
								   @"board_uuid": self.board.uuid,
								   @"invitee_email": self.emailField.text,
								   @"invitee_firstname": self.firstNameField.text,
								   @"invitee_lastname": self.lastNameField.text
								   };
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	SNFUserService *userService = [[SNFUserService alloc] init];
	[userService inviteWithData:userRoleData andCompletion:^(NSError *error) {
		[MBProgressHUD hideAllHUDsForView:self.view animated:YES];
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				NSLog(@"%@", error.localizedDescription);
			}else{
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[self presentViewController:alert animated:YES completion:^{}];
			}
		}else{
			NSString *message = [NSString stringWithFormat:@"%@ has been invited to your board %@.", self.emailField.text, self.board.title];
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:YES completion:^{}];
			_completion(nil, nil);
		}
	}];
}

- (BOOL)validBoard{
	if(!self.board){
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Could not find board" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return NO;
	}
	return YES;
}

- (BOOL)validName{
	if(self.firstNameField.text.length < 1 || [self.firstNameField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1){
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Enter a first name" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return NO;
	}
	return YES;
}

- (BOOL)validEmail{
	if(self.emailField.text.length < 1 || [self.emailField.text stringByReplacingOccurrencesOfString:@" " withString:@""].length < 1) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Enter an email address" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return NO;
	}
	if(![self.emailField.text isValidEmail]) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Form Error" message:@"Email must be valid" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:NULL]];
		[self presentViewController:alert animated:TRUE completion:NULL];
		return NO;
	}
	return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	[textField resignFirstResponder];
	return NO;
}

- (IBAction)openGenderPicker:(id)sender{
	[self.genderPickerContainer matchFrameSizeOfView:self.view];
	[self.view addSubview:self.genderPickerContainer];
}

- (IBAction)closeGenderPicker:(UIButton *)sender{
	[self.genderPickerContainer removeFromSuperview];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return _pickerValues.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	NSDictionary *pickerVal = [_pickerValues objectAtIndex:row];
	for(NSString *key in pickerVal){
		return [pickerVal objectForKey:key];
	}
	return @"";
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	NSDictionary *pickerVal = [_pickerValues objectAtIndex:row];
	for(NSString *key in pickerVal){
		self.genderField.text = [pickerVal objectForKey:key];
	}
}

@end
