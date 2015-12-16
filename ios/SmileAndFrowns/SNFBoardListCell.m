#import "SNFBoardListCell.h"
#import "SNFUserRole.h"

@implementation SNFBoardListCell

- (void) awakeFromNib {
	[super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	self.titleLabel.text = board.title;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"L/d/yy"];
	self.dateLabel.text = [formatter stringFromDate:board.created_date];
	
	NSString *userRole = [self.board permissionForUser:[SNFModel sharedInstance].loggedInUser];
	if(!userRole || [userRole isEqualToString:SNFUserRoleGuardian] || [userRole isEqualToString:SNFUserRoleChild]){
		self.swipeEnabled = NO;
	}else if([userRole isEqualToString:SNFUserRoleParent]){
		self.resetButtonWidthConstraint.constant = 0.0;
		self.resetButton.hidden = YES;
		self.swipeEnabled = YES;
	}else if([userRole isEqualToString:@"owner"]){
		self.resetButtonWidthConstraint.constant = self.controlsUnderlay.frame.size.width/2;
		self.resetButton.hidden = NO;
		self.swipeEnabled = YES;
	}
}

- (IBAction)onEdit:(UIButton *)sender{
	if(self.delegate){
		[self.delegate boardListCell:self wantsToEditBoard:self.board];
	}
}

- (IBAction)onReset:(UIButton *)sender{
	if(self.delegate){
		[self.delegate boardListCell:self wantsToResetBoard:self.board];
	}
}

@end
