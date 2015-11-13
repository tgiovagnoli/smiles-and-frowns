
#import "SNFBoardDetailAdultCell.h"
#import "UIImageView+LocalCache.h"

@implementation SNFBoardDetailAdultCell

- (void) setUser:(SNFUser *)user{
	_user = user;
	
	NSString *title = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
	if(!user.first_name || [user.first_name isEqualToString:@""]){
		title = user.username;
	}
	
	self.nameLabel.text = title;
	self.noteLabel.text = @"";
	
	if(_user.image) {
		
		NSURL * url = [NSURL URLWithString:_user.image];
		[self.profileImageView setImageForURL:url withCompletion:^(NSError *error, UIImage *image) {
			if(error) {
				[self setImageFromGender];
			}
		}];
		
	} else {
		[self setImageFromGender];
	}
}

- (void) setImageFromGender {
	if([_user.gender isEqualToString:SNFUserGenderFemale]){
		self.profileImageView.image = [UIImage imageNamed:@"female"];
	}else{
		self.profileImageView.image = [UIImage imageNamed:@"male"];
	}
}

- (void)setUserRole:(SNFUserRole *)userRole{
	_userRole = userRole;
	if(userRole){
		self.swipeEnabled = YES;
	}else{
		self.swipeEnabled = NO;
	}
}

- (IBAction)onDelete:(UIButton *)sender{
	if(self.delegate && self.userRole){
		[self.delegate adultCell:self wantsToRemoveUserRole:self.userRole];
	}
}

@end
