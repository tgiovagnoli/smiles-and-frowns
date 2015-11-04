#import <UIKit/UIKit.h>

@class SNFAddCell;

@protocol SNFAddCellDelegate <NSObject>
- (void)addCellWantsToAdd:(SNFAddCell *)addCell;
@end

@interface SNFAddCell : UICollectionViewCell

@property (weak) IBOutlet UIButton *addButton;
@property (weak) NSObject <SNFAddCellDelegate> *delegate;

- (IBAction)onAdd:(UIButton *)sender;

@end
