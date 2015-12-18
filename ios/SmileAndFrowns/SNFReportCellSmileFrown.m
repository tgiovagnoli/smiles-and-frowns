
#import "SNFReportCellSmileFrown.h"

@implementation SNFReportCellSmileFrown

- (void) setBehaviorGroup:(SNFReportBehaviorGroup2 *) behaviorGroup {
	_behaviorGroup = behaviorGroup;
	
	SNFBehavior * behavior = nil;
	SNFUser * creator = nil;
	NSString * note = nil;
	
	switch (_behaviorGroup.type) {
		
		case SNFReportBehaviorGroupTypeFrown:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) behaviorGroup.objects.count];
			behavior = [((SNFFrown *) behaviorGroup.objects.firstObject) behavior];
			creator = [((SNFFrown *) behaviorGroup.objects.firstObject) creator];
			note = [((SNFFrown *) behaviorGroup.objects.firstObject) note];
			self.smileFrownImageView.image = [UIImage imageNamed:@"frown"];
			break;
		
		case SNFReportBehaviorGroupTypeSmile:
			self.countLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long) behaviorGroup.objects.count];
			behavior = [((SNFSmile *) behaviorGroup.objects.firstObject) behavior];
			creator = [((SNFSmile *) behaviorGroup.objects.firstObject) creator];
			note = [((SNFSmile *) behaviorGroup.objects.firstObject) note];
			self.smileFrownImageView.image = [UIImage imageNamed:@"smile"];
			break;
	}
	
	self.behaviorLabel.text = behavior.title;
	self.creatorLabel.text = [NSString stringWithFormat:@"%@ %@", creator.first_name, creator.last_name];
	self.noteLabel.text = note;
	
}

@end
