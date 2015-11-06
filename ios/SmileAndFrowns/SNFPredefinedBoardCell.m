#import "SNFPredefinedBoardCell.h"

@implementation SNFPredefinedBoardCell


- (void)setPredefinedBoard:(SNFPredefinedBoard *)predefinedBoard{
	_predefinedBoard = predefinedBoard;
	if(predefinedBoard){
		self.titleLabel.text = predefinedBoard.title;
	}else{
		self.titleLabel.text = @"Custom board";
	}
}

@end
