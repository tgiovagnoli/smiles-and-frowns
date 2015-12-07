
#import "SNFSwipeCell.h"
#import "NSTimer+Blocks.h"

@interface SNFSwipeCell ()
@property BOOL firstlayout;
@end

@implementation SNFSwipeCell

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	_swipeEnabled = YES;
	self.firstlayout = TRUE;
	self.clipsToBounds = TRUE;
	self.layer.masksToBounds = TRUE;
	self.layoutMargins = UIEdgeInsetsZero;
	self.contentView.layoutMargins = UIEdgeInsetsZero;
	return self;
}

- (void) layoutSubviews {
	[super layoutSubviews];
	if(self.firstlayout) {
		[self setupGestureRecognizer];
		self.firstlayout = FALSE;
	}
}

- (void) prepareForReuse {
	[super prepareForReuse];
	[self resetSwipeState];
}

- (void) resetSwipeState {
	self.overlayView.frame = CGRectMake(0.0, 0.0, self.overlayView.frame.size.width, self.overlayView.frame.size.height);
}

- (void) setupGestureRecognizer {
	if(!self.minimumThreshold) {
		self.minimumThreshold = 45.0;
	}
	
	if(_gr) {
		[self removeGestureRecognizer:_gr];
	}
	
	_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureChange:)];
	_gr.minimumNumberOfTouches = 1;
	_gr.maximumNumberOfTouches = 1;
	_gr.delegate = self;
	[self addGestureRecognizer:_gr];
	
	[self.contentView insertSubview:self.controlsUnderlay atIndex:0];
	CGRect editFrame = CGRectMake(self.contentView.frame.size.width - self.controlsUnderlay.frame.size.width, 0.0f, self.controlsUnderlay.frame.size.width, self.frame.size.height);
	self.controlsUnderlay.frame = editFrame;
}

- (void) onGestureChange:(UISwipeGestureRecognizer *) gr {
	if(!_swipeEnabled) {
		return;
	}
	
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

- (BOOL) gestureRecognizer:(UIGestureRecognizer *) gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *) otherGestureRecognizer {
	return YES;
}

- (void) startSwipe:(UISwipeGestureRecognizer *) gr {
	_hasHitThreshold = NO;
	self.controlsUnderlay.frame = CGRectMake(self.contentView.frame.size.width - self.controlsUnderlay.frame.size.width, 0.0f, self.controlsUnderlay.frame.size.width, self.frame.size.height);
	_startPoint = [gr locationInView:self];
	_startPoint.x -= self.overlayView.frame.origin.x;
}

- (void) changeSwipe:(UISwipeGestureRecognizer *) gr {
	CGPoint newPoint = [gr locationInView:self];
	CGPoint offset = CGPointMake(newPoint.x - _startPoint.x, 0.0f);
	
	if(offset.x > 0.0f) {
		offset.x = 0.0f;
	}
	
	if(fabs(offset.x) > self.minimumThreshold && !_hasHitThreshold) {
		_hasHitThreshold = YES;
	}
	
	if(!_hasHitThreshold) {
		return;
	}
	
	self.overlayView.frame = CGRectMake(offset.x, offset.y, self.overlayView.frame.size.width, self.overlayView.frame.size.height);
}

- (void) endSwipe:(UISwipeGestureRecognizer *) gr {
	CGPoint newPoint = [gr locationInView:self];
	CGPoint offset = CGPointMake(newPoint.x - _startPoint.x, 0.0f);
	float halfSize = -self.controlsUnderlay.frame.size.width/2;
	
	if(offset.x < halfSize) {
		offset.x = -self.controlsUnderlay.frame.size.width;
	} else {
		offset.x = 0;
	}
	
	[UIView animateWithDuration:0.2f animations:^{
		self.overlayView.frame = CGRectMake(offset.x, offset.y, self.overlayView.frame.size.width, self.overlayView.frame.size.height);
	}];
}

- (void) dealloc {
	[self removeGestureRecognizer:_gr];
	_gr = nil;
	self.overlayView = nil;
	self.controlsUnderlay = nil;
}

@end
