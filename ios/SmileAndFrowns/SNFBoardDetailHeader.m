
#import "SNFBoardDetailHeader.h"
#import "UIColor+Hex.h"

@implementation SNFBoardDetailHeader

- (void) layoutSubviews {
	[super layoutSubviews];
	self.textLabel.textColor = [UIColor whiteColor];
	self.textLabel.font = [UIFont fontWithName:@"Roboto-Light" size:16];
	self.contentView.backgroundColor = [UIColor colorWithHexString:@"#d6b685"];
	//self.textLabel.textAlignment = NSTextAlignmentCenter;
}

@end
