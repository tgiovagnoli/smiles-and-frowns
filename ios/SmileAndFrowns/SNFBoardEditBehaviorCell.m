
#import "SNFBoardEditBehaviorCell.h"
#import "SNFFormStyles.h"

@implementation SNFBoardEditBehaviorCell

- (void) awakeFromNib {
	[super awakeFromNib];
	//self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void) setBehavior:(SNFBehavior *) behavior {
	_behavior = behavior;
	self.titleLabel.text = behavior.title;
}

- (IBAction) onDelete:(UIButton *) sender {
	if(self.delegate) {
		[self.delegate behaviorCell:self wantsToDeleteBehavior:self.behavior];
	}
}

- (void) setSelected:(BOOL)selected animated:(BOOL) animated {
	[super setSelected:selected animated:animated];
	if(selected) {
		[self.deleteButton setTitleColor:[SNFFormStyles darkGray] forState:UIControlStateNormal];
		self.deleteButton.backgroundColor = [SNFFormStyles darkSandColor];
		self.titleLabel.textColor = [SNFFormStyles lightSandColor];
	} else {
		[self.deleteButton setTitleColor:[SNFFormStyles lightSandColor] forState:UIControlStateNormal];
		self.deleteButton.backgroundColor = [SNFFormStyles darkGray];
		self.titleLabel.textColor = [SNFFormStyles darkGray];
	}
}

@end
