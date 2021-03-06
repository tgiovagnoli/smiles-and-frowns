
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "UIView+LayoutHelpers.h"
#import "SNFDebug.h"
#import "UIViewControllerStack.h"
#import "SNFTabMenu.h"
#import "SNFUserProfile.h"
#import "NSLog+Geom.h"
#import "APDDjangoErrorViewer.h"
#import "UIViewController+Alerts.h"

@interface SNFViewController : UIViewController <APDDebugViewControllerDelegate,GADBannerViewDelegate>

@property (weak) IBOutlet UIViewControllerStack * viewControllerStack;
@property (weak) IBOutlet UIView * tabMenuContainer;
@property (weak) IBOutlet NSLayoutConstraint * tabMenuContainerBottom;

@property SNFTabMenu * tabMenu;
@property SNFTab firstTab;
@property SNFADBannerView * bannerView;

+ (SNFViewController *) instance;

- (void) showDebug;
- (void) showBoardsAnimated:(BOOL) animated;
- (void) showProfile;
- (void) showMore;
- (void) showInvitesAnimated:(BOOL) animated;

- (BOOL) isAdDisplayed;

- (void) showErrorMessage:(NSString *)errorMessage;

@end
