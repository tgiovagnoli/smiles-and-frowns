
#import "SNFTabMenu.h"
#import "SNFViewController.h"

@implementation SNFTabMenu

- (void) viewDidLoad {
	[self setActive:self.boardsButton];
	
	NSLog(@"%@", ((UIButton *)[self.buttons objectAtIndex:1]).backgroundColor);
}

- (void) removeShadows {
	for(UIButton * button in self.buttons) {
		button.layer.shadowOffset = CGSizeZero;
		button.layer.shadowOpacity = 0;
		button.layer.shadowRadius = 0;
	}
}

- (void) setActive:(id) sender {
	[self removeShadows];
	
	for(UIButton * button in self.buttons) {
		button.backgroundColor = [UIColor colorWithRed:0.290196 green:0.290196 blue:0.290196 alpha:1];
		if(button == sender) {
			button.backgroundColor = [UIColor colorWithRed:1 green:0.832 blue:0.235 alpha:1];
			button.layer.shadowOffset = CGSizeMake(0,1);
			button.layer.shadowOpacity = .2;
			button.layer.shadowRadius = 1;
			button.layer.shadowColor = [[UIColor blackColor] CGColor];
		}
	}
}

- (void) setActiveSection:(SNFTab) section; {
	if(section == SNFTabBoards) {
		[self onBoards:self.boardsButton];
	}
	
	if(section == SNFTabInvites) {
		[self onInvites:self.invitesButton];
	}
	
	if(section == SNFTabMore) {
		[self onMore:self.moreButton];
	}
	
	if(section == SNFTabProfile) {
		[self onProfile:self.profileButton];
	}
}

- (IBAction)onDebug:(UIButton *)sender{
	[[SNFViewController instance] showDebug];
	[self setActive:sender];
}

- (IBAction)onBoards:(UIButton *)sender{
	[[SNFViewController instance] showBoardsAnimated:TRUE];
	[self setActive:sender];
}

- (IBAction)onProfile:(UIButton *)sender{
	[[SNFViewController instance] showProfile];
	[self setActive:sender];
}

- (IBAction)onInvites:(UIButton *)sender{
	[[SNFViewController instance] showInvitesAnimated:TRUE];
	[self setActive:sender];
}

- (IBAction)onMore:(UIButton *)sender{
	[[SNFViewController instance] showMore];
	[self setActive:sender];
}

@end
