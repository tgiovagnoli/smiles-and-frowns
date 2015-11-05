
#import "SNFAddUserRole.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFModel.h"
#import "SNFUserRole.h"
#import "UIViewController+Alerts.h"
#import "SNFUserService.h"

NSString * const SNFAddUserRoleAddedChild = @"SNFAddUserRoleAddedChild";

@interface SNFAddUserRole ()
@property NSArray * genders;
@end

@implementation SNFAddUserRole

- (void) viewDidLoad {
	[super viewDidLoad];
	self.genders = @[@"--------",@"Male",@"Female"];
	self.pickerview.delegate = self;
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
}

- (IBAction) segmentChange:(id)sender {
	if(self.segment.selectedSegmentIndex > 0) {
		self.age.hidden = TRUE;
		self.genderOverlay.hidden = TRUE;
		self.gender.hidden = TRUE;
	} else {
		self.age.hidden = FALSE;
		self.genderOverlay.hidden = FALSE;
		self.gender.hidden = FALSE;
	}
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
	
	NSString * gender = @"";
	
	if(![self.gender.text isEmpty]) {
		gender = [self.gender.text lowercaseString];
	}
	
	NSNumber * age = [NSNumber numberWithInteger:[self.age.text integerValue]];
	
	NSDictionary *info = @{
		@"role":@"child",
		@"board":@{@"uuid": self.board.uuid},
		@"user":@{
			@"first_name": self.firstname.text,
			@"last_name": self.lastname.text,
			@"email": self.email.text,
			@"age":age,
			@"gender":gender
		}
	};
	
	[SNFUserRole editOrCreatefromInfoDictionary:info withContext:[SNFModel sharedInstance].managedObjectContext];
	[[SNFModel sharedInstance].managedObjectContext save:nil];
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFAddUserRoleAddedChild object:nil];
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
	
	SNFUserService * service = [[SNFUserService alloc] init];
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
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[service inviteWithData:data andCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
		} else {
			[self displayOKAlertWithTitle:@"Success" message:[NSString stringWithFormat:@"Invited %@ to board %@",self.email.text,self.board.title] completion:nil];
		}
	}];
}

- (IBAction) genderOverlay:(id) sender {
	self.pickerviewContainer.frame = self.view.bounds;
	[self.view addSubview:self.pickerviewContainer];
}

- (IBAction) closeGenderPicker:(id)sender {
	[self.pickerviewContainer removeFromSuperview];
}

- (IBAction) addPerson:(id) sender {
	if(self.segment.selectedSegmentIndex == 0) {
		[self addChildRole];
	} else {
		[self sendInvite];
	}
}

- (IBAction) cancel:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
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
}

- (void) contactPickerDidCancel:(CNContactPickerViewController *)picker {
	[self dismissViewControllerAnimated:TRUE completion:nil];
}

@end
