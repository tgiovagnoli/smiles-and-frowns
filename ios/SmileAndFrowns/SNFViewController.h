#import <UIKit/UIKit.h>
#import "UIView+LayoutHelpers.h"
#import "SNFDebug.h"
#import "UIViewControllerStack.h"
#import "SNFTabMenu.h"



@interface SNFViewController : UIViewController <APDDebugViewControllerDelegate>

@property (weak) IBOutlet UIViewControllerStack *viewControllerStack;
@property (weak) IBOutlet UIView *tabMenuContainer;
@property SNFTabMenu *tabMenu;

+ (SNFViewController *)rootViewController;

- (void)showDebug;
- (void)showBoards;
- (void)showProfile;
- (void)showMore;
- (void)showInvites;

@end

