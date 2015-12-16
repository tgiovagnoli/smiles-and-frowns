
#import "SNFReportPDFDetailRow.h"

@interface SNFReportPDFDetailRow ()
@end

@implementation SNFReportPDFDetailRow

- (void) viewDidLoad {
	[super viewDidLoad];
	
	SNFBehavior * behavior = nil;
	SNFUser * creator = nil;
	NSString * note = nil;
	
	if(self.behaviorGroup.type == SNFReportBehaviorGroupTypeFrown) {
		behavior = [[[self.behaviorGroup frowns] firstObject] behavior];
		creator = [[[self.behaviorGroup frowns] firstObject] creator];
		note = [[[self.behaviorGroup frowns] firstObject] note];
		self.imageView.image = [UIImage imageNamed:@"frown"];
		self.smileFrownCount.text = [NSString stringWithFormat:@"%lu",self.behaviorGroup.frowns.count];
	} else {
		behavior = [[[self.behaviorGroup smiles] firstObject] behavior];
		creator = [[[self.behaviorGroup smiles] firstObject] creator];
		note = [[[self.behaviorGroup smiles] firstObject] note];
		self.imageView.image = [UIImage imageNamed:@"smile"];
		self.smileFrownCount.text = [NSString stringWithFormat:@"%lu",self.behaviorGroup.smiles.count];
	}
	
	self.behavior.text = behavior.title;
	self.note.text = note;
	
	NSMutableString * name = [[NSMutableString alloc] initWithString:@"From "];
	
	if(creator.first_name) {
		[name appendString:creator.first_name];
	}
	
	if(creator.last_name) {
		[name appendString:@" "];
		[name appendString:creator.last_name];
	}
	
	self.user.text = name;
}

- (void) hideSeperator; {
	self.seperator.hidden = TRUE;
}

@end
