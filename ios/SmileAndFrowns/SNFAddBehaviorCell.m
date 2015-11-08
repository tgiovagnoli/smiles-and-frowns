
#import "SNFAddBehaviorCell.h"
#import "SNFModel.h"

@interface SNFAddBehaviorCell ()
@property BOOL previousSelectedValue;
@end

@implementation SNFAddBehaviorCell

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if(selected) {
		self.editButton.layer.backgroundColor = [[UIColor colorWithRed:0.678 green:0.678 blue:0.678 alpha:1] CGColor];
		[self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	} else {
		self.editButton.layer.backgroundColor = [[UIColor colorWithRed:0.801 green:0.801 blue:0.801 alpha:1] CGColor];
		[self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	[self.editButton setNeedsDisplay];
}

- (IBAction) onEdit:(id) sender {
	self.behaviorTitleField.userInteractionEnabled = TRUE;
	if([self.behaviorTitleField.text isEqualToString:@"Untitled"]) {
		self.behaviorTitleField.text = @"";
	}
	[self.behaviorTitleField becomeFirstResponder];
}

- (void) awakeFromNib {
	self.behaviorTitleField.delegate = self;
	[self.behaviorTitleField addTarget:self action:@selector(onTitleUpdate:) forControlEvents:UIControlEventEditingChanged];
	self.editButton.layer.cornerRadius = 8;
	self.editButton.layer.backgroundColor = [[UIColor colorWithRed:0.801 green:0.801 blue:0.801 alpha:1] CGColor];
	[self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (void) setBehavior:(SNFPredefinedBehavior *) behavior {
	_behavior = behavior;
	self.behaviorTitleField.text = _behavior.title;
}

- (BOOL) textFieldShouldBeginEditing:(UITextField *) textField {
	self.editButton.hidden = TRUE;
	return TRUE;
}

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
	[textField resignFirstResponder];
	
	if([textField.text isEmpty]) {
		textField.text = @"Untitled";
	}
	
	self.behaviorTitleField.userInteractionEnabled = FALSE;
	self.editButton.hidden = FALSE;
	self.behavior.title = self.behaviorTitleField.text;
	
	return YES;
}

- (void) onTitleUpdate:(UITextField *) sender {
	if([self.behaviorTitleField.text isEmpty] || [self.behaviorTitleField.text isEqualToString:@"Untitled"]){
		return;
	}
	self.behavior.title = self.behaviorTitleField.text;
	[[SNFModel sharedInstance].managedObjectContext save:nil];
}

@end
