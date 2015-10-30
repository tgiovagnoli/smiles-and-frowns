#import "SNFAddUserRole.h"
#import "AppDelegate.h"
#import "SNFModel.h"

@implementation SNFAddUserRole


- (void)setBoard:(SNFBoard *)board andCompletion:(SNFAddUserRoleCallback)completion{
	_completion = completion;
	_board = board;
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
								   }
						   };
	SNFUserRole *userRole = (SNFUserRole *)[SNFUserRole editOrCreatefromInfoDictionary:info withContext:[SNFModel sharedInstance].managedObjectContext];
	_completion(nil, userRole);
}

- (void)createInvite{
	// TODO: Create an invite
	_completion(nil, nil);
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

@end
