#import "SNFReportCellSmileFrown.h"

@implementation SNFReportCellSmileFrown

- (void)setBehaviorGroup:(SNFReportBehaviorGroup *)behaviorGroup{
	_behaviorGroup = behaviorGroup;
	
	SNFBehavior * behavior = nil;
	
	SNFUser * creator = nil;
	
	NSString * note = nil;
	
	switch (_behaviorGroup.type) {
		case SNFReportBehaviorGroupTypeFrown:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)behaviorGroup.frowns.count];
			behavior = [[[behaviorGroup frowns] firstObject] behavior];
			creator = [[[behaviorGroup frowns] firstObject] creator];
			note = [[[behaviorGroup frowns] firstObject] note];
			self.smileFrownImageView.image = [UIImage imageNamed:@"frown"];
			break;
		case SNFReportBehaviorGroupTypeSmile:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)behaviorGroup.smiles.count];
			behavior = [[[behaviorGroup smiles] firstObject] behavior];
			creator = [[[behaviorGroup smiles] firstObject] creator];
			note = [[[behaviorGroup smiles] firstObject] note];
			self.smileFrownImageView.image = [UIImage imageNamed:@"smile"];
			break;
	}
	
	self.behaviorLabel.text = behavior.title;
	self.creatorLabel.text = [NSString stringWithFormat:@"%@ %@", creator.first_name, creator.last_name];
	self.noteLabel.text = note;
}

@end
