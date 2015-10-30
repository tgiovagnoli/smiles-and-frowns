#import "SNFTabMenu.h"
#import "SNFViewController.h"

@implementation SNFTabMenu

- (IBAction)onDebug:(UIButton *)sender{
	[[SNFViewController instance] showDebug];
}

- (IBAction)onBoards:(UIButton *)sender{
	[[SNFViewController instance] showBoardsAnimated:TRUE];
}

- (IBAction)onProfile:(UIButton *)sender{
	[[SNFViewController instance] showProfile];
}

- (IBAction)onInvites:(UIButton *)sender{
	[[SNFViewController instance] showInvitesAnimated:TRUE];
}

- (IBAction)onMore:(UIButton *)sender{
	[[SNFViewController instance] showMore];
}

@end
