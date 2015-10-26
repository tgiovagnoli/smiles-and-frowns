#import "APDLoadingView.h"

@implementation APDLoadingView


- (id)init{
	self = [super init];
	[self setup];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	[self setup];
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	[self setup];
	return self;
}

- (void)setup{
	_activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
	_activityIndicator.translatesAutoresizingMaskIntoConstraints = NO;
	self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8];
	[self addSubview:_activityIndicator];
	[_activityIndicator centerHorizonalByConstraintInView:self];
	[_activityIndicator centerVerticalByConstraintInView:self];
	
}

- (void)start{
	UIView *hostView = self.containerView;
	if(!hostView){
		hostView = [[UIApplication sharedApplication] delegate].window.rootViewController.view;
	}
	[hostView addSubview:self];
	[self.activityIndicator startAnimating];
	[self matchFrameSizeOfView:hostView];
	self.alpha = 0.0;
	[UIView animateWithDuration:0.25 delay:self.fadeDelay options:UIViewAnimationOptionCurveLinear animations:^{
		self.alpha = 1.0;
	} completion:^(BOOL finished) {}];
}

- (void)stop{
	[self removeFromSuperview];
	[self.activityIndicator stopAnimating];
	[UIView animateWithDuration:0.25 animations:^{
		self.alpha = 0.0;
	}];
}

@end
