#import "SNFPredefinedBoardCell.h"

@implementation SNFPredefinedBoardCell

- (void) awakeFromNib {
	[super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self setSeparatorInset:UIEdgeInsetsZero];
	self.preservesSuperviewLayoutMargins = FALSE;
}

- (void)setPredefinedBoard:(SNFPredefinedBoard *)predefinedBoard{
	_predefinedBoard = predefinedBoard;
	if(predefinedBoard){
		self.titleLabel.text = predefinedBoard.title;
	}else{
		self.titleLabel.text = @"Custom board";
	}
}

@end
