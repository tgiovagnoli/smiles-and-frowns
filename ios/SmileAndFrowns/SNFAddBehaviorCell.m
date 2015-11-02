#import "SNFAddBehaviorCell.h"

@implementation SNFAddBehaviorCell

- (void)setBehavior:(SNFPredefinedBehavior *)behavior{
	_behavior = behavior;
	self.behaviorTitleField.text = _behavior.title;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
	if([self.behaviorTitleField.text isEmpty] || [self.behaviorTitleField.text isEqualToString:@"Untitled"]){
		//TODO add alert
		NSLog(@"must not be null or untitled");
		return NO;
	}
	self.behavior.title = self.behaviorTitleField.text;
	[textField resignFirstResponder];
	return NO;
}

@end
