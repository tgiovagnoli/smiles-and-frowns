
#import "UIViewController+ModalCreation.h"

@implementation UIViewController (ModalCreation)

- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize; {
	self = [self init];
	
	self.modalPresentationStyle = UIModalPresentationPopover;
	self.popoverPresentationController.sourceView = view;
	self.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
	
	if(CGRectEqualToRect(sourceRect, CGRectZero)) {
		self.popoverPresentationController.sourceRect = CGRectMake((view.width/2)-5,(view.height/2)-5,10,10);
	} else {
		self.popoverPresentationController.sourceRect = sourceRect;
	}
	
	if(!CGSizeEqualToSize(contentSize, CGSizeZero)) {
		self.preferredContentSize = contentSize;
	}
	
	return self;
}

@end
