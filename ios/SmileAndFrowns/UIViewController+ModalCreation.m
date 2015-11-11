
#import "UIViewController+ModalCreation.h"
#import "AppDelegate.h"

@implementation UIViewController (ModalCreation)

- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize; {
	return [self initWithSourceView:view sourceRect:sourceRect contentSize:contentSize arrowDirections:UIPopoverArrowDirectionAny];
}

- (id) initWithSourceView:(UIView *) view sourceRect:(CGRect) sourceRect contentSize:(CGSize) contentSize arrowDirections:(UIPopoverArrowDirection) arrowDirections; {
	self = [self init];
	
	UIView * sourceView = view;
	CGRect sourceRectUpdated = sourceRect;
	
	if(!sourceView) {
		sourceView = [AppDelegate rootViewController].view;
		sourceRectUpdated = CGRectMake([UIScreen mainScreen].bounds.size.width/2,30,10,10);
	}
	
	self.modalPresentationStyle = UIModalPresentationPopover;
	self.popoverPresentationController.sourceView = sourceView;
	self.popoverPresentationController.permittedArrowDirections = arrowDirections;
	
	if(CGRectEqualToRect(sourceRectUpdated, CGRectZero)) {
		self.popoverPresentationController.sourceRect = CGRectMake((view.width/2)-5,(view.height/2)-5,10,10);
	} else {
		self.popoverPresentationController.sourceRect = sourceRectUpdated;
	}
	
	if(!CGSizeEqualToSize(contentSize, CGSizeZero)) {
		self.preferredContentSize = contentSize;
	}
	
	return self;
}

@end
