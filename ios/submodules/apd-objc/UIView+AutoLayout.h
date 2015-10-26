
#import <UIKit/UIKit.h>

@interface UIView (AutoLayout)

- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) attribute;
- (void) removeConstraintsWithSecondAttribute:(NSLayoutAttribute) attribute;
- (void) removeConstraintsWithFirstAttribute:(NSLayoutAttribute) firstAttribute secondAttribute:(NSLayoutAttribute) secondAttribute;
- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(UIView *) view;
- (void) alignEdgeByConstraint:(NSLayoutAttribute) edge toView:(UIView *) view atOffset:(CGFloat) offset;
- (void) setWidthByConstraint:(CGFloat) width;
- (void) setHeightByConstraint:(CGFloat) height;
- (void) centerHorizonalByConstraintInView:(UIView *) view;
- (void) centerVerticalByConstraintInView:(UIView *) view;
- (void) matchHeightByConstraintToView:(UIView *) view;
- (void) matchWidthByConstraintToView:(UIView *) view;

- (NSLayoutConstraint *) constraintWithFirstAttribute:(NSLayoutAttribute) attribute;

@end
