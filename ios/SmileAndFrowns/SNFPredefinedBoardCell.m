
#import "SNFPredefinedBoardCell.h"
#import "SNFFormStyles.h"

@implementation SNFPredefinedBoardCell

- (void) awakeFromNib {
	[super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
	[self setSeparatorInset:UIEdgeInsetsZero];
	self.preservesSuperviewLayoutMargins = FALSE;
	
	[SNFFormStyles roundEdgesOnButton:self.purchase];
}

- (void) setPredefinedBoard:(SNFPredefinedBoard *) predefinedBoard {
	_predefinedBoard = predefinedBoard;
	if(predefinedBoard) {
		self.titleLabel.text = predefinedBoard.title;
	} else {
		self.titleLabel.text = @"Custom board";
	}
}

- (IBAction) purchase:(id)sender {
	if(self.delegate) {
		[self.delegate boardCellWantsToPurchase:self];
	}
}

@end
