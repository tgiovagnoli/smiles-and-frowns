
#import "SNFModalViewController.h"

@interface SNFModalViewController ()
@end

@implementation SNFModalViewController

- (id) initModalSourceView:(UIView *) view sourceRect:(CGRect) rect {
	self = [super init];
	self.modalPresentationStyle = UIModalPresentationPopover;
	self.popoverPresentationController.sourceView = view;
	self.popoverPresentationController.sourceRect = rect;
	return self;
}

@end
