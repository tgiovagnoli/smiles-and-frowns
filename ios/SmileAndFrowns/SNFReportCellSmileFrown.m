
#import "SNFReportCellSmileFrown.h"

@implementation SNFReportCellSmileFrown

- (void) prepareForReuse {
	self.smileFrownImageView.image = nil;
}

- (void) setBehaviorGroupV1:(SNFReportBehaviorGroup *) behaviorGroup {
	SNFBehavior * behavior = nil;
	SNFUser * creator = nil;
	NSString * note = nil;
	switch (behaviorGroup.type) {
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

- (void) setBehaviorGroup:(SNFReportBehaviorGroup2 *) behaviorGroup {
	SNFBehavior * behavior = nil;
	SNFUser * creator = nil;
	NSString * note = nil;
	switch (behaviorGroup.type) {
			
		case SNFReportBehaviorGroupTypeFrown:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) behaviorGroup.objects.count];
			behavior = [((SNFFrown *) behaviorGroup.objects.firstObject) behavior];
			creator = [((SNFFrown *) behaviorGroup.objects.firstObject) creator];
			note = behaviorGroup.notes;
			self.smileFrownImageView.image = [UIImage imageNamed:@"frown"];
			break;
			
		case SNFReportBehaviorGroupTypeSmile:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) behaviorGroup.objects.count];
			behavior = [((SNFSmile *) behaviorGroup.objects.firstObject) behavior];
			creator = [((SNFSmile *) behaviorGroup.objects.firstObject) creator];
			note = behaviorGroup.notes;
			self.smileFrownImageView.image = [UIImage imageNamed:@"smile"];
			break;
	}
	
	self.behaviorLabel.text = behavior.title;
	self.creatorLabel.text = [NSString stringWithFormat:@"%@ %@", creator.first_name, creator.last_name];
	self.noteLabel.text = note;
}

@end
