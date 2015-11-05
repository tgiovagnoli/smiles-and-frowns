
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIView+LayoutHelpers.h"
#import "SNFDebug.h"
#import "UIViewControllerStack.h"
#import "SNFTabMenu.h"
#import "SNFUserProfile.h"
#import "NSLog+Geom.h"

@interface SNFViewController : UIViewController <APDDebugViewControllerDelegate,ADBannerViewDelegate>

@property (weak) IBOutlet UIViewControllerStack * viewControllerStack;
@property (weak) IBOutlet UIView * tabMenuContainer;
@property IBOutlet NSLayoutConstraint * tabMenuContainerBottom;

@property SNFTabMenu * tabMenu;
@property SNFTab firstTab;
@property ADBannerView * bannerView;

+ (SNFViewController *) instance;

- (void) showDebug;
- (void) showBoardsAnimated:(BOOL) animated;
- (void) showProfile;
- (void) showMore;
- (void) showInvitesAnimated:(BOOL) animated;

- (BOOL) isAdDisplayed;

@end
