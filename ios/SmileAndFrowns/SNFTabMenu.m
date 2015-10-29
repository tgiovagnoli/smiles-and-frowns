#import "SNFTabMenu.h"
#import "SNFViewController.h"

@implementation SNFTabMenu

- (IBAction)onDebug:(UIButton *)sender{
	[[SNFViewController rootViewController] showDebug];
}

- (IBAction)onBoards:(UIButton *)sender{
	[[SNFViewController rootViewController] showBoards];
}

- (IBAction)onProfile:(UIButton *)sender{
	[[SNFViewController rootViewController] showProfile];
}

- (IBAction)onInvites:(UIButton *)sender{
	[[SNFViewController rootViewController] showInvites];
}

- (IBAction)onMore:(UIButton *)sender{
	[[SNFViewController rootViewController] showMore];
}

@end
