#import "SNFBoardListCell.h"

@implementation SNFBoardListCell


- (void)setBoard:(SNFBoard *)board{
	_board = board;
	self.titleLabel.text = board.title;
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setDateFormat:@"L/d/yy"];
	self.dateLabel.text = [formatter stringFromDate:board.created_date];
}

@end
