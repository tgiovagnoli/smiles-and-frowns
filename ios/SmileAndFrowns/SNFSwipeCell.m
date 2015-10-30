#import "SNFSwipeCell.h"

@implementation SNFSwipeCell

- (id)init{
	self = [super init];
	[self setupGestureRecognizer];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	[self setupGestureRecognizer];
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	[self setupGestureRecognizer];
	return self;
}

- (void)awakeFromNib{
	[super awakeFromNib];
	[self setupGestureRecognizer];
}

- (void)setupGestureRecognizer{
	self.layoutMargins = UIEdgeInsetsZero;
	self.contentView.layoutMargins = UIEdgeInsetsZero;
	
	_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureChange:)];
	_gr.minimumNumberOfTouches = 1;
	_gr.maximumNumberOfTouches = 1;
	_gr.delegate = self;
	
	[self.contentView addSubview:self.controlsUnderlay];
	[self.contentView insertSubview:self.controlsUnderlay atIndex:0];
	self.controlsUnderlay.frame = CGRectMake(self.contentView.frame.size.width - self.controlsUnderlay.frame.size.width, 0.0f, self.controlsUnderlay.frame.size.width, self.frame.size.height);
	
	[self addGestureRecognizer:_gr];
	[self updateMask];
}

- (void)onGestureChange:(UISwipeGestureRecognizer *)gr{
	switch (gr.state) {
		case UIGestureRecognizerStateBegan:
			[self startSwipe:gr];
			break;
		case UIGestureRecognizerStateEnded:
			[self endSwipe:gr];
			break;
		case UIGestureRecognizerStateCancelled:
			[self endSwipe:gr];
			break;
		case UIGestureRecognizerStateChanged:
			[self changeSwipe:gr];
			break;
		case UIGestureRecognizerStateFailed:
			break;
		case UIGestureRecognizerStatePossible:
			break;
	}
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
	return YES;
}

- (void)startSwipe:(UISwipeGestureRecognizer *)gr{
	self.controlsUnderlay.frame = CGRectMake(self.contentView.frame.size.width - self.controlsUnderlay.frame.size.width, 0.0f, self.controlsUnderlay.frame.size.width, self.frame.size.height);
	_startPoint = [gr locationInView:self];
	_startPoint.x -= self.overlayView.frame.origin.x;
	[self updateMask];
}

- (void)changeSwipe:(UISwipeGestureRecognizer *)gr{
	CGPoint newPoint = [gr locationInView:self];
	CGPoint offset = CGPointMake(newPoint.x - _startPoint.x, 0.0f);
	if(offset.x > 0.0f){
		offset.x = 0.0f;
	}
	self.overlayView.frame = CGRectMake(offset.x, offset.y, self.overlayView.frame.size.width, self.overlayView.frame.size.height);
	[self updateMask];
}

- (void)endSwipe:(UISwipeGestureRecognizer *)gr{
	CGPoint newPoint = [gr locationInView:self];
	CGPoint offset = CGPointMake(newPoint.x - _startPoint.x, 0.0f);
	float halfSize = -self.controlsUnderlay.frame.size.width/2;
	
	if(offset.x < halfSize){
		offset.x = -self.controlsUnderlay.frame.size.width;
	}else{
		offset.x = 0.0f;
	}
	[UIView animateWithDuration:0.2f animations:^{
		self.overlayView.frame = CGRectMake(offset.x, offset.y, self.overlayView.frame.size.width, self.overlayView.frame.size.height);
		[self updateMask];
	}];
}

- (void)updateMask{
	CGFloat pos = self.controlsUnderlay.frame.size.width + self.overlayView.frame.origin.x;
	CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
	CGRect maskRect = CGRectMake(pos, 0, self.frame.size.width, self.controlsUnderlay.frame.size.height);
	CGPathRef path = CGPathCreateWithRect(maskRect, NULL);
	maskLayer.path = path;
	CGPathRelease(path);
	
	// Set the mask of the view.
	self.controlsUnderlay.layer.mask = maskLayer;
}

- (void)updateUIForDrag{
	static CGFloat size = 16.0;
	if(_bulletsView){
		[_bulletsView removeFromSuperview];
		_bulletsView = nil;
	}
	_bulletsView = [[UIImageView alloc] initWithFrame:CGRectMake(self.overlayView.frame.size.width - size, 0.0, size, self.overlayView.frame.size.height)];
	_bulletsView.contentMode = UIViewContentModeCenter;
	_bulletsView.image = [UIImage imageNamed:@"drag_bullets"];
	[self.overlayView addSubview:_bulletsView];
}

- (void)finishUIForDrag{
	[_bulletsView removeFromSuperview];
	_bulletsView = nil;
}

- (void)dealloc{
	[self removeGestureRecognizer:_gr];
	_gr = nil;
	self.overlayView = nil;
	self.controlsUnderlay = nil;
}

@end
