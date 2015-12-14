
#import "SNFBoardDetailAdultCell.h"
#import "UIImageView+DiskCache.h"
#import "NSString+Additions.h"
#import "UIImageView+ProfileStyle.h"

@implementation SNFBoardDetailAdultCell

- (void) awakeFromNib {
	self.profileImageView.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.profileImageView.layer.shadowOffset = CGSizeMake(0,2);
	self.profileImageView.layer.shadowOpacity = .2;
	self.profileImageView.layer.shadowRadius = 1;
}

- (void) setUser:(SNFUser *)user{
	_user = user;
	
	NSString *title = [NSString stringWithFormat:@"%@ %@", user.first_name, user.last_name];
	if(!user.first_name || [user.first_name isEqualToString:@""]){
		title = user.username;
	}
	
	self.nameLabel.text = title;
	
	[self setImageFromGender];
	
	if(![_user.image isEmpty] && _user.image) {
		NSURL * url = [NSURL URLWithString:_user.image];
		[self.profileImageView setImageWithDefaultAuthBasicForURL:url withCompletion:^(NSError *error, UIImage *image) {
			[self.profileImageView setImage:image asProfileWithBorderColor:[UIColor whiteColor] andBorderThickness:2];
			if(error) {
				[self setImageFromGender];
			}
		}];
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
