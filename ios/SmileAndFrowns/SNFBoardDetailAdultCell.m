#import "SNFBoardDetailAdultCell.h"

@implementation SNFBoardDetailAdultCell

- (void)setUser:(SNFUser *)user{
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

@end
