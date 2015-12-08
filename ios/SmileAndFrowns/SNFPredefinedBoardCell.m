#import "SNFPredefinedBoardCell.h"

@implementation SNFPredefinedBoardCell

- (void) awakeFromNib {
	self.selectionStyle = UITableViewCellSelectionStyleNone;
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
