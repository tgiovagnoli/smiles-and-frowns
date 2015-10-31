
#import <UIKit/UIKit.h>
#import "UIView+LayoutHelpers.h"
#import "SNFDebug.h"
#import "UIViewControllerStack.h"
#import "SNFTabMenu.h"
#import "SNFUserProfile.h"

@interface SNFViewController : UIViewController <APDDebugViewControllerDelegate>

@property (weak) IBOutlet UIViewControllerStack *viewControllerStack;
@property (weak) IBOutlet UIView *tabMenuContainer;
@property SNFTabMenu *tabMenu;
@property SNFTab firstTab;

+ (SNFViewController *)instance;
- (void)showDebug;
- (void)showBoardsAnimated:(BOOL) animated;
- (void)showProfile;
- (void)showMore;
- (void)showInvitesAnimated:(BOOL) animated;

@end
