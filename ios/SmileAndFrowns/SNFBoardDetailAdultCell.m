#import "SNFBoardDetailAdultCell.h"

@implementation SNFBoardDetailAdultCell

- (void)setUserRole:(SNFUserRole *)userRole{
	_userRole = userRole;
	
	SNFUser *user = _userRole.user;
	
	NSString *title = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
	if(!user.first_name || [user.first_name isEqualToString:@""]){
		title = user.username;
	}
	self.nameLabel.text = title;
	self.noteLabel.text = @"";
}

@end
