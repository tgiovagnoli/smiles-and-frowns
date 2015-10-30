#import "SNFBoardListCell.h"

@implementation SNFBoardListCell

- (void)awakeFromNib{
	[super awakeFromNib];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	self.titleLabel.text = board.title;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"L/d/yy"];
	self.dateLabel.text = [formatter stringFromDate:board.created_date];
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
