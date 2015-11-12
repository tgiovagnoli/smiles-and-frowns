#import "SNFBoardDetailAdultCell.h"

@implementation SNFBoardDetailAdultCell

- (void)setUser:(SNFUser *)user{
	_user = user;
	NSString *title = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
	if(!user.first_name || [user.first_name isEqualToString:@""]){
		title = user.username;
	}
	self.nameLabel.text = title;
	self.noteLabel.text = @"";
	
	if([user.gender isEqualToString:SNFUserGenderFemale]){
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
