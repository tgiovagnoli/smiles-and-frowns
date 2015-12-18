
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
		behavior = [((SNFFrown *) self.behaviorGroup.objects.firstObject) behavior];
		creator = [((SNFFrown *) self.behaviorGroup.objects.firstObject) creator];
		note = [((SNFFrown *) self.behaviorGroup.objects.firstObject) note];
		self.imageView.image = [UIImage imageNamed:@"frown"];
		self.smileFrownCount.text = [NSString stringWithFormat:@"%lu",self.behaviorGroup.objects.count];
	} else {
		behavior = [((SNFSmile *) self.behaviorGroup.objects.firstObject) behavior];
		creator = [((SNFSmile *) self.behaviorGroup.objects.firstObject) creator];
		note = [((SNFSmile *) self.behaviorGroup.objects.firstObject) note];
		self.imageView.image = [UIImage imageNamed:@"smile"];
		self.smileFrownCount.text = [NSString stringWithFormat:@"%lu",self.behaviorGroup.objects.count];
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
