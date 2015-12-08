#import <UIKit/UIKit.h>

@interface SNFSwipeCell : UITableViewCell{
	UIPanGestureRecognizer *_gr;
	CGPoint _startPoint;
	UIImageView *_bulletsView;
	BOOL _hasHitThreshold;
}

@property (strong) IBOutlet UIView *overlayView;
@property (strong) IBOutlet UIView *controlsUnderlay;
@property (nonatomic) BOOL swipeEnabled;
@property CGFloat minimumThreshold;

- (void)updateMask;
- (void)resetSwipeState;

@end
