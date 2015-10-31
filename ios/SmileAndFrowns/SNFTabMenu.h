#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SNFTab) {
	SNFTabDefault,
	SNFTabBoards,
	SNFTabProfile,
	SNFTabInvites,
	SNFTabMore,
	SNFTabDebug,
};

@interface SNFTabMenu : UIViewController

- (IBAction)onDebug:(UIButton *)sender;
- (IBAction)onBoards:(UIButton *)sender;
- (IBAction)onProfile:(UIButton *)sender;
- (IBAction)onInvites:(UIButton *)sender;
- (IBAction)onMore:(UIButton *)sender;

@end
