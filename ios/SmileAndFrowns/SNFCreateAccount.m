
#import "SNFCreateAccount.h"
#import "AppDelegate.h"
#import "NSString+Additions.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"

@interface SNFCreateAccount ()
@property BOOL firstlayout;
@end

@implementation SNFCreateAccount

- (void) viewDidLoad {
	[super viewDidLoad];
	self.firstlayout = true;
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
	self.scrollViewBottom.constant = keyboardFrameEnd.size.height;
}

- (void) keyboardWillHide:(NSNotification *) notification {
	self.scrollViewBottom.constant = 0;
}

- (IBAction) signup:(id)sender {
	NSString * msg = nil;
	NSString * title = @"Form Error";
	
	if([self.email.text isEmpty]) {
		msg = @"Email required";
	}
	
	if(!msg && ![self.email.text isValidEmail]) {
		msg = @"Incorrect email format";
	}
	
	if(!msg && self.firstname.text.isEmpty) {
		msg = @"First Name required";
	}
	
	if(!msg && self.lastname.text.isEmpty) {
		msg = @"Last Name required";
	}
	
	if(!msg && self.password.text.isEmpty) {
		msg = @"Password required";
	}
	
	if(!msg && self.passwordConfirm.text.isEmpty) {
		msg = @"Password Confirm required";
	}
	
	if(!msg && ![self.passwordConfirm.text isEqualToString:self.password.text]) {
		msg = @"Password and Password Confirm do not match";
	}
	
	if(msg) {
		UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
		[self presentViewController:alert animated:TRUE completion:nil];
		return;
	}
	
	SNFUserService * service = [[SNFUserService alloc] init];
	
	NSDictionary * data = @{
		@"email":self.email.text,
		@"firstname":self.firstname.text,
		@"lastname":self.lastname.text,
		@"password":self.password.text,
		@"password_confirm":self.passwordConfirm.text,
	};
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[service createAccountWithData:data andCompletion:^(NSError * error, SNFUser *user) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
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
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

@end
