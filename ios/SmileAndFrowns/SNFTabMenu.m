#import "SNFTabMenu.h"
#import "SNFViewController.h"

@implementation SNFTabMenu

- (IBAction)onDebug:(UIButton *)sender{
	[[SNFViewController instance] showDebug];
}

- (IBAction)onBoards:(UIButton *)sender{
	[[SNFViewController instance] showBoards];
}

- (IBAction)onProfile:(UIButton *)sender{
	[[SNFViewController instance] showProfile];
}

- (IBAction)onInvites:(UIButton *)sender{
	[[SNFViewController instance] showInvites];
}

- (IBAction)onMore:(UIButton *)sender{
	[[SNFViewController instance] showMore];
}

@end
