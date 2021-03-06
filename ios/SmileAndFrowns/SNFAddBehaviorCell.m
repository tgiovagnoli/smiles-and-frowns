
#import "SNFAddBehaviorCell.h"
#import "SNFModel.h"
#import "SNFSyncService.h"
#import "SNFFormStyles.h"

@interface SNFAddBehaviorCell ()
@property BOOL previousSelectedValue;
@end

@implementation SNFAddBehaviorCell

- (void) setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
	if(selected) {
		self.behaviorTitleField.textColor = [SNFFormStyles lightSandColor];
		self.editButton.layer.backgroundColor = [[SNFFormStyles lightSandColor] CGColor];
		[self.editButton setTitleColor:[SNFFormStyles darkGray] forState:UIControlStateNormal];
	} else {
		self.behaviorTitleField.textColor = [SNFFormStyles darkGray];
		self.editButton.layer.backgroundColor = [[SNFFormStyles darkGray] CGColor];
		[self.editButton setTitleColor:[SNFFormStyles lightSandColor] forState:UIControlStateNormal];
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
	self.editButton.layer.cornerRadius = 10;
	self.editButton.layer.backgroundColor = [[UIColor colorWithRed:0.801 green:0.801 blue:0.801 alpha:1] CGColor];
	[self.editButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	self.behaviorTitleField.userInteractionEnabled = NO;
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
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
	[[SNFSyncService instance] saveContext];
}

- (void)setEditable:(BOOL)editable{
	_editable = editable;
	for(UIGestureRecognizer *rec in self.gestureRecognizers){
		[self removeGestureRecognizer:rec];
	}
	if(editable){
		UILongPressGestureRecognizer *gr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
		gr.minimumPressDuration = 0.5;
		[self addGestureRecognizer:gr];
	}
}

- (void)onLongPress:(UIGestureRecognizer *)gr{
	NSLog(@"on long press");
	[self.textLabel becomeFirstResponder];
}

@end
