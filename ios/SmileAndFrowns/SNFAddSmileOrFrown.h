#import <UIKit/UIKit.h>
#import "UIAlertAction+Additions.h"
#import "SNFBoard.h"
#import "SNFFrown.h"
#import "SNFSmile.h"
#import "SNFBehavior.h"
#import "SNFBoardEditBehaviorCell.h"
#import "SNFAddBehavior.h"
#import "SNFFormViewController.h"


typedef NS_ENUM(NSInteger, SNFAddSmileOrFrownType){
	SNFAddSmileOrFrownTypeSmile,
	SNFAddSmileOrFrownTypeFrown,
};

@class SNFAddSmileOrFrown;

@protocol SNFAddSmileOrFrownDelegate <NSObject>
- (void)addSmileOrFrownFinished:(SNFAddSmileOrFrown *)addSoF;
@end

@interface SNFAddSmileOrFrown : UIViewController <UITableViewDelegate, UITableViewDataSource, SNFBoardEditBehaviorCellDelegate, SNFAddBehaviorDelegate>{
	NSArray *_behaviors;
}

@property (weak) IBOutlet UITableView *behaviorsTable;
@property (weak) IBOutlet UIStepper *amountStepper;
@property (weak) IBOutlet UITextField *amountField;
@property (weak) IBOutlet UIImageView *snfTypeImageView;
@property (weak) IBOutlet UIButton *addBehaviorButton;
@property (weak) IBOutlet UIButton *addSNFButton;
@property (weak) IBOutlet UIButton *cancelButton;
@property (weak) IBOutlet UITextView *noteField;

@property IBOutlet NSLayoutConstraint * cancelButtonBottom;

@property (nonatomic) SNFBoard *board;
@property (nonatomic) SNFAddSmileOrFrownType type;
@property SNFUser *user;
@property NSObject <SNFAddSmileOrFrownDelegate> *delegate;

- (IBAction)onAddBehavior:(UIButton *)sender;
- (IBAction)onAddSmileOrFrown:(UIButton *)sender;
- (IBAction)onCancel:(UIButton *)sender;
- (IBAction)onSmileAmountUpdate:(UIStepper *)sender;

@end