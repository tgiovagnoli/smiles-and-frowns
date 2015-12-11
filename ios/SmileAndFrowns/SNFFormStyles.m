
#import "SNFFormStyles.h"

@implementation SNFFormStyles

+ (void) roundEdgesOnButton:(UIButton *) button {
	[button.layer setMasksToBounds:YES];
	[button.layer setCornerRadius:8];
}

+ (void)updateFontOnSegmentControl:(UISegmentedControl *)segmentControl{
	UIFont *font = [UIFont fontWithName:@"Roboto-Regular" size:12.0];
	NSDictionary *attributes = [NSDictionary dictionaryWithObject:font forKey:NSFontAttributeName];
	[segmentControl setTitleTextAttributes:attributes forState:UIControlStateNormal];
}

+ (UIColor *) darkGray; {
	return [UIColor colorWithRed:0.290196 green:0.290196 blue:0.290196 alpha:1];
}

+ (UIColor *) lightSandColor; {
	return [UIColor colorWithRed:0.984314 green:0.960784 blue:0.92549 alpha:1];
}

+ (UIColor *) darkSandColor; {
	return [UIColor colorWithRed:0.94902 green:0.917647 blue:0.87451 alpha:1];
}

@end
