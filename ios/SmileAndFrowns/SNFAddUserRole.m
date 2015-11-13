
#import "SNFAddUserRole.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFModel.h"
#import "SNFUserRole.h"
#import "UIViewController+Alerts.h"
#import "SNFUserService.h"
#import "SNFUser.h"

NSString * const SNFAddUserRoleAddedChild = @"SNFAddUserRoleAddedChild";

@interface SNFAddUserRole ()
@property NSArray * genders;
@property NSDictionary * inviteData;
@property NSString * tmpImageUUID;
@property NSString * tmpImageURL;
@end

@implementation SNFAddUserRole

- (void) viewDidLoad {
	[super viewDidLoad];
	[self startBannerAd];
	
	_genderPicker = [[SNFValuePicker alloc] init];
	_genderPicker.delegate = self;
	_genderPicker.values = [SNFUser genderSelections];
	
	_agePicker = [[SNFValuePicker alloc] init];
	_agePicker.delegate = self;
	_agePicker.values = [SNFUser ageSelections];
	
	[self.ageOverlay setTitle:@"" forState:UIControlStateNormal];
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
	[self segmentChange:self.segment];
	
	UIGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickImage:)];
	[self.image addGestureRecognizer:tapGestureRecognizer];
	self.image.userInteractionEnabled = YES;
}

- (IBAction) segmentChange:(id)sender {
	if(self.segment.selectedSegmentIndex > 0) {
		self.age.hidden = TRUE;
		self.genderOverlay.hidden = TRUE;
		self.ageOverlay.hidden = TRUE;
		self.gender.hidden = TRUE;
		self.email.placeholder = @"Email";
		self.email.hidden = NO;
	} else {
		self.age.hidden = FALSE;
		self.genderOverlay.hidden = FALSE;
		self.ageOverlay.hidden = FALSE;
		self.gender.hidden = FALSE;
		self.email.placeholder = @"Email (Optional)";
		self.email.hidden = YES; // do not use email to create users that are not part of the invite system.
	}
	[self updateProfileImage];
}

- (void) addChildRole {
	if(!self.board) {
		[self displayOKAlertWithTitle:@"Error" message:@"Board required" completion:nil];
		return;
	}
	
	if([self.firstname.text isEmpty]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"First Name required" completion:nil];
		return;
	}
	
	if([self.lastname.text isEmpty]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"Last Name required" completion:nil];
		return;
	}
	
	// check to see if a child exists
	NSFetchRequest * request = [NSFetchRequest fetchRequestWithEntityName:@"SNFUser"];
	request.predicate = [NSPredicate predicateWithFormat:@"(first_name CONTAINS[cd] %@) && (last_name CONTAINS[cd] %@)", self.firstname.text, self.lastname.text];
	NSArray * results = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:request error:nil];
	
	if(results.count > 0) {
		NSString * message = [NSString stringWithFormat:@"Would you like to associate one of these existing users with this board?"];
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleActionSheet];
		NSInteger userIndex = 0;
		
		for(SNFUser * user in results) {
			NSString * userName = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
			
			SNFTaggedAlertAction * childAction = [SNFTaggedAlertAction actionWithTitle:userName style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				SNFTaggedAlertAction *alertAction = (SNFTaggedAlertAction *)action;
				SNFUser * selectedUser = [results objectAtIndex:alertAction.tag];
				[self addChildRoleWithUser:selectedUser];
			}];
			
			childAction.tag = userIndex;
			[alert addAction:childAction];
			
			userIndex++;
		}
		
		[alert addAction:[UIAlertAction actionWithTitle:@"Create As New Child" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			[self addChildRoleWithUser:nil];
		}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
		
		[self presentViewController:alert animated:YES completion:^{}];
		
	} else {
		[self addChildRoleWithUser:nil];
	}
}

- (void) addChildRoleWithUser:(SNFUser *) user {
	NSManagedObjectContext * context = [SNFModel sharedInstance].managedObjectContext;
	if(!user) {
		NSString * gender = @"";
		
		if(![self.gender.text isEmpty]) {
			gender = [self.gender.text lowercaseString];
		}
		
		NSNumber * age = [NSNumber numberWithInteger:[self.age.text integerValue]];
		NSDictionary *userInfo = @{
			@"first_name": self.firstname.text,
			@"last_name": self.lastname.text,
			@"email": self.email.text,
			@"age":age,
			@"gender":gender
		};
		
		user = (SNFUser *)[SNFUser editOrCreatefromInfoDictionary:userInfo withContext:context];
	}
	
	if(self.tmpImageUUID) {
		user.tmp_profile_image_uuid = self.tmpImageUUID;
	}
	
	if(self.tmpImageURL) {
		user.image = self.tmpImageURL;
	}
	
	//if(_userSelectedImage) {
	//	[user updateProfileImage:_userSelectedImage];
	//}
	
	NSDictionary * info = @{
		@"role":@"child",
		@"board":@{@"uuid": self.board.uuid},
		@"user": [user infoDictionary]
	};
	
	[SNFUserRole editOrCreatefromInfoDictionary:info withContext:[SNFModel sharedInstance].managedObjectContext];
	[[SNFSyncService instance] saveContext];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFAddUserRoleAddedChild object:nil];
	
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (void) sendInvite {
	if(!self.board) {
		[self displayOKAlertWithTitle:@"Error" message:@"Board required" completion:nil];
		return;
	}
	
	if([self.firstname.text isEmpty]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"First Name required" completion:nil];
		return;
	}
	
	if([self.lastname.text isEmpty]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"Last Name required" completion:nil];
		return;
	}
	
	if([self.email.text isEmpty]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"Email required" completion:nil];
		return;
	}
	
	if(![self.email.text isValidEmail]) {
		[self displayOKAlertWithTitle:@"Form Error" message:@"Incorrect email format" completion:nil];
		return;
	}
	
	NSMutableDictionary * data = [NSMutableDictionary dictionary];
	data[@"board_uuid"] = self.board.uuid;
	data[@"invitee_email"] = self.email.text;
	data[@"invitee_firstname"] = self.firstname.text;
	data[@"invitee_lastname"] = self.lastname.text;
	
	if(self.segment.selectedSegmentIndex == 1) {
		data[@"role"] = @"parent";
	} else if(self.segment.selectedSegmentIndex == 2) {
		data[@"role"] = @"guardian";
	}
	
	self.inviteData = data;
	[self syncAndSendInvite:nil];
}

- (void) syncAndSendInvite:(NSNotification *) note {
	[MBProgressHUD hideAllHUDsForView:self.view animated:TRUE];
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self name:SNFSyncServiceCompleted object:nil];
	
	if([SNFSyncService instance].syncing) {
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(syncAndSendInvite:) name:SNFSyncServiceCompleted object:nil];
		return;
	}
	
	SNFUserService * service = [[SNFUserService alloc] init];
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		
		if(error) {
			if(error.code == SNFErrorCodeDjangoDebugError) {
				APDDjangoErrorViewer * djangoView = [[APDDjangoErrorViewer alloc] init];
				[djangoView showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"invite"]];
				[self presentViewController:djangoView animated:YES completion:^{}];
			} else {
				[MBProgressHUD hideHUDForView:self.view animated:TRUE];
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
			}
			return;
		}
		
		//make sure boards are synced
		[service inviteWithData:self.inviteData andCompletion:^(NSError *error) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				if(error.code == SNFErrorCodeDjangoDebugError) {
					APDDjangoErrorViewer *djangoView = [[APDDjangoErrorViewer alloc] init];
					[djangoView showErrorData:error.localizedDescription forURL:[[SNFModel sharedInstance].config apiURLForPath:@"invite"]];
					[self presentViewController:djangoView animated:YES completion:^{}];
				} else {
					[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				}
			} else {
				[self displayOKAlertWithTitle:@"Success" message:[NSString stringWithFormat:@"Invited %@ to board %@",self.email.text,self.board.title] completion:^(UIAlertAction *action) {
					[self dismissViewControllerAnimated:YES completion:^{}];
				}];
			}
		}];
	}];
}

- (IBAction) ageOverlay:(id) sender {
	[_agePicker.view matchFrameSizeOfView:self.view];
	[self.view addSubview:_agePicker.view];
	_agePicker.selectedValue = self.age.text;
}

- (IBAction) genderOverlay:(id) sender {
	[_genderPicker.view matchFrameSizeOfView:self.view];
	[self.view addSubview:_genderPicker.view];
	_genderPicker.selectedValue = self.gender.text;
}

- (void)valuePicker:(SNFValuePicker *)valuePicker changedValue:(NSString *)value{
	if(valuePicker == _agePicker){
		[self updateAgeWithValue:value];
	}else if(valuePicker == _genderPicker){
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
	[self updateProfileImage];
}

- (void)valuePickerFinished:(SNFValuePicker *)valuePicker{
	[valuePicker.view removeFromSuperview];
}

- (IBAction) addPerson:(id) sender {
	if(self.segment.selectedSegmentIndex == 0) {
		[self addChildRole];
	} else {
		[self sendInvite];
	}
}

- (IBAction) cancel:(id)sender {
	if(self.presentingViewController) {
		[self.presentingViewController dismissViewControllerAnimated:TRUE completion:nil];
	}
}

- (IBAction) addFromContacts:(id) sender {
	CNContactPickerViewController  * picker = [[CNContactPickerViewController  alloc] init];
	picker.delegate = self;
	[self presentViewController:picker animated:YES completion:nil];
}

- (void) contactPicker:(CNContactPickerViewController *)picker didSelectContact:(CNContact *)contact {
	[self dismissViewControllerAnimated:YES completion:nil];
	
	if(contact.emailAddresses.count > 0) {
		self.email.text = [contact.emailAddresses firstObject].value;
	} else {
		self.email.text = @"";
	}
	
	if(contact.givenName) {
		self.firstname.text = contact.givenName;
	} else {
		self.firstname.text = @"";
	}
	
	if(contact.familyName) {
		self.lastname.text = contact.familyName;
	} else {
		self.lastname.text = @"";
	}
	
	if(contact.birthday) {
		NSDate *bday = [contact.birthday date];
		NSDate *now = [NSDate date];
		NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
		// pass as many or as little units as you like here, separated by pipes
		NSUInteger units = NSCalendarUnitYear;
		NSDateComponents * components = [gregorian components:units fromDate:bday toDate:now options:0];
		NSInteger years = [components year];
		self.age.text = [NSString stringWithFormat:@"%ld", (long)years];
	} else {
		self.age.text = @"";
	}
	
	if(contact.imageDataAvailable){
		UIImage *contactImage = [UIImage imageWithData:contact.imageData];
		if(contactImage){
			_userSelectedImage = contactImage;
		}
	}
	[self updateProfileImage];
}

- (void) contactPickerDidCancel:(CNContactPickerViewController *)picker {
	[self dismissViewControllerAnimated:TRUE completion:nil];
}

- (void)pickImage:(UIGestureRecognizer *)gr{
	if(self.segment.selectedSegmentIndex != 0){
		return;
	}
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.delegate = self;
	imagePicker.allowsEditing = YES;
	[self presentViewController:imagePicker animated:YES completion:^{}];
}

- (void) updateProfileImage {
	if(_userSelectedImage && self.segment.selectedSegmentIndex == 0){
		self.image.image = _userSelectedImage;
	}else if([self.gender.text isEqualToString:@"Female"]){
		self.image.image = [UIImage imageNamed:@"female"];
	}else{
		self.image.image = [UIImage imageNamed:@"male"];
	}
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
	UIImage * image = [info objectForKey:UIImagePickerControllerEditedImage];
	_userSelectedImage = [image imageCroppedFromSize:CGSizeMake(300,300)];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self dismissViewControllerAnimated:YES completion:^{
		
		SNFUserService * service = [SNFUserService new];
		
		[service uploadTempUserProfileImage:_userSelectedImage withCompletion:^(NSError *error, NSString *uuid, NSString *url) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			[self updateProfileImage];
			self.tmpImageURL = url;
			self.tmpImageUUID = uuid;
			
		}];
		
	}];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

@end
