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

@property IBOutletCollection(UIButton) NSArray * buttons;
@property (weak) IBOutlet UIButton * boardsButton;
@property (weak) IBOutlet UIButton * invitesButton;
@property (weak) IBOutlet UIButton * moreButton;
@property (weak) IBOutlet UIButton * profileButton;

- (void) setActiveSection:(SNFTab) section;

@end
