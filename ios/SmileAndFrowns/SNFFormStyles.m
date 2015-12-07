
#import "SNFFormStyles.h"

@implementation SNFFormStyles

+ (void)roundEdgesOnButton:(UIButton *)button{
	[button.layer setMasksToBounds:YES];
	[button.layer setCornerRadius:5.0f];
}

+ (void)updateFontOnSegmentControl:(UISegmentedControl *)segmentControl{
	UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

+ (UIColor *) darkGray; {
	return [UIColor colorWithRed:0.290196 green:0.290196 blue:0.290196 alpha:1];
}

@end
