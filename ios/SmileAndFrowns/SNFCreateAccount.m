
#import "SNFCreateAccount.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"
#import "SNFLogin.h"
#import "NSTimer+Blocks.h"

@interface SNFCreateAccount ()
@property BOOL firstlayout;
@property NSArray * genders;
@property NSTimer * pickerTimer;
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
	self.genders = @[@"--------",@"Male",@"Female"];
	self.pickerView.delegate = self;
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) viewDidLayoutSubviews {
	if(self.firstlayout) {
		self.firstlayout = false;
		self.formView.frame = self.scrollView.bounds;
		self.scrollView.contentSize = self.scrollView.size;
		[self.scrollView addSubview:self.formView];
	}
}

- (void) keyboardWillShow:(NSNotification *) notification {
	NSDictionary * userInfo = notification.userInfo;
	CGRect keyboardFrameEnd = [userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
	keyboardFrameEnd = [self.view convertRect:keyboardFrameEnd fromView:nil];
	if(self.scrollViewBottom.constant == keyboardFrameEnd.size.height) {
		return;
	}
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
	self.formView.height = 460;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
}

- (void) keyboardWillHide:(NSNotification *) notification {
	if(self.scrollViewBottom.constant == 0) {
		return;
	}
	self.scrollViewBottom.constant = 0;
	self.scrollView.contentSize = CGSizeMake(self.scrollView.width,self.formView.height);
	[NSTimer scheduledTimerWithTimeInterval:.2 block:^{
		self.formView.height = self.scrollView.height;
	} repeats:FALSE];
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

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return self.genders.count;
}

- (NSString *) pickerView:(UIPickerView *) pickerView titleForRow:(NSInteger)row forComponent:(NSInteger) component {
	return [self.genders objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if(row == 0) {
		return;
	}
	self.gender.text = [self.genders objectAtIndex:row];
}

- (IBAction) closePicker:(id)sender {
	[self.pickerviewContainer removeFromSuperview];
}

- (IBAction) signup:(id) sender {
	SNFUserService * service = [[SNFUserService alloc] init];
	
	NSDictionary * data = @{
		@"email":self.email.text,
		@"firstname":self.firstname.text,
		@"lastname":self.lastname.text,
		@"password":self.password.text,
		@"password_confirm":self.passwordConfirm.text,
		@"gender":self.gender.text.lowercaseString,
		@"age":self.age.text,
	};
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[service createAccountWithData:data andCompletion:^(NSError * error, SNFUser *user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Signup Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			
		} else {
			
			[SNFModel sharedInstance].loggedInUser = user;
			
			[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
				if(self.nextViewController) {
					[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
				}
			}];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction) login:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		[[AppDelegate rootViewController] presentViewController:[[SNFLogin alloc] init] animated:TRUE completion:nil];
	}];
}

@end
