
#import <UIKit/UIKit.h>

@interface SNFTutorial : UIViewController

//make sure to set view.tag in interface builder so they're ordered properly
@property IBOutletCollection(UIView) NSArray * views;
@property (weak) IBOutlet UIScrollView * scrollView;

+ (BOOL) hasSeenTutorial;

@end
