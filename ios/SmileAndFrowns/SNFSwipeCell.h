#import <UIKit/UIKit.h>

@interface SNFSwipeCell : UITableViewCell{
	UIPanGestureRecognizer *_gr;
	CGPoint _startPoint;
	UIImageView *_bulletsView;
}

@property (strong) IBOutlet UIView *overlayView;
@property (strong) IBOutlet UIView *controlsUnderlay;

- (void)updateUIForDrag;
- (void)finishUIForDrag;
- (void)updateMask;


@end
