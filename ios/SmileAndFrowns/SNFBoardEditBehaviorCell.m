#import "SNFBoardEditBehaviorCell.h"

@implementation SNFBoardEditBehaviorCell

- (void)setBehavior:(SNFBehavior *)behavior{
	_behavior = behavior;
	self.titleLabel.text = behavior.title;
}

- (IBAction)onDelete:(UIButton *)sender{
	if(self.delegate){
		[self.delegate behaviorCell:self wantsToDeleteBehavior:self.behavior];
	}
}

@end
