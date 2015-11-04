#import "SNFAddCell.h"

@implementation SNFAddCell

- (IBAction)onAdd:(UIButton *)sender{
	if(self.delegate){
		[self.delegate addCellWantsToAdd:self];
	}
}

@end
