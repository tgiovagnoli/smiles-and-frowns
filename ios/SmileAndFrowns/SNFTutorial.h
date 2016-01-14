
#import <UIKit/UIKit.h>

@interface SNFTutorial : UIViewController <UIScrollViewDelegate>

//make sure to set view.tag in interface builder so they're ordered properly
@property IBOutletCollection(UIView) NSArray * views;

@property (weak) IBOutlet UIButton * getStarted;
@property (weak) IBOutlet UIScrollView * scrollView;
@property (weak) IBOutlet UIPageControl * pageControl;

@property IBOutletCollection(UILabel) NSArray * labelsWithShadow;

@property BOOL userInitiatedTutorial;

+ (BOOL) hasSeenTutorial;

+ (SNFTutorial *) tutorialInstance;

@end
