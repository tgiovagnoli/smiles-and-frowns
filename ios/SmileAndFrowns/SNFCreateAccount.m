
#import "SNFCreateAccount.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"
#import "SNFLogin.h"
#import "NSTimer+Blocks.h"
#import "ATIFacebookAuthHandler.h"
#import "UIAlertAction+Additions.h"
#import "SNFSyncService.h"
#import "UIViewController+Alerts.h"

@interface SNFCreateAccount ()
@property SNFUserService * service;
@property NSArray * genders;
@property NSTimer * pickerTimer;
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
	self.service = [[SNFUserService alloc] init];
	self.genders = @[@"--------",@"Male",@"Female"];
	self.pickerView.delegate = self;
	[self.genderOverlay setTitle:@"" forState:UIControlStateNormal];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacebookLogin:) name:ATIFacebookAuthHandlerSessionChange object:nil];
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
			
			[self displayOKAlertWithTitle:@"Signup Error" message:error.localizedDescription completion:nil];
			
		} else {
			
			[SNFModel sharedInstance].loggedInUser = user;
			[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
			
			[self closeModal];
		}
	}];
}

- (IBAction) cancel:(id)sender {
	[self.view endEditing:TRUE];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
	[SNFModel sharedInstance].pendingInviteCode = nil;
}

- (IBAction) login:(id)sender {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		
		SNFLogin * login = [[SNFLogin alloc] init];
		
		if(self.nextViewController) {
			login.nextViewController = self.nextViewController;
		}
		
		[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
	}];
}

- (IBAction) facebook:(id) sender {
	[[ATIFacebookAuthHandler instance] login];
}

- (void) onFacebookLogin:(NSNotification *) notification {
	FBSessionState state = (FBSessionState)[[[notification userInfo] objectForKey:@"state"] unsignedIntegerValue];
	NSString * msg = [notification userInfo][@"msg"];
	
	if(state == FBSessionStateOpen) {
		NSString * authToken = FBSession.activeSession.accessTokenData.accessToken;
		[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
		
		[self.service loginWithFacebookAuthToken:authToken withCompletion:^(NSError *error, SNFUser *user) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				return;
			}
			
			BOOL hasUserChanged = (![user.username isEqualToString:[[SNFModel sharedInstance] lastLoggedInUsername]]);
			[SNFModel sharedInstance].loggedInUser = user;
			
			[self syncAfterLogin:hasUserChanged];
			
		}];
		
	} else if(msg) {
		
		[self displayOKAlertWithTitle:@"Error:" message:msg completion:nil];
		
	}
}

- (void) syncAfterLogin:(BOOL) hasUserChanged {
	
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	hud.labelText = @"Syncing Board Data";
	
	if(hasUserChanged) {
		[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
	}
	
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Sync Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		[self syncPredefinedBoards];
	}];
}

- (void) syncPredefinedBoards {
	MBProgressHUD * hud = [MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	hud.labelText = @"Syncing Board Data";
	
	[[SNFSyncService instance] syncPredefinedBoardsWithCompletion:^(NSError *error, NSObject *boardData) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			[self displayOKAlertWithTitle:@"Sync Error" message:error.localizedDescription completion:nil];
			return;
		}
		
		[self closeModal];
	}];
}

- (void) closeModal {
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
		if(self.nextViewController) {
			[[AppDelegate rootViewController] presentViewController:self.nextViewController animated:TRUE completion:nil];
		}
	}];
}

@end
