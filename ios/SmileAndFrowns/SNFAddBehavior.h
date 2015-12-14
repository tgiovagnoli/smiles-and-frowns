
#import <UIKit/UIKit.h>
#import "SNFPredefinedBehaviorGroup.h"
#import "SNFPredefinedBehavior.h"
#import "SNFAddBehaviorCell.h"
#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFFormViewController.h"
#import "GATracking.h"
#import "SNFFormStyles.h"

@class SNFAddBehavior;

@protocol SNFAddBehaviorDelegate <NSObject>
- (void)addBehavior:(SNFAddBehavior *)addBehavior addedBehaviors:(NSArray *)behaviors toBoard:(SNFBoard *)board;
- (void)addBehaviorCancelled:(SNFAddBehavior *)addBehavior;
@end

@interface SNFAddBehavior : SNFFormViewController <UITableViewDataSource, UITableViewDelegate>{
	NSArray *_predefinedBehaviorGroups;
	SNFPredefinedBehavior *_selectedBehavior;
}

@property BOOL selectNegativeOnLoad;
@property BOOL disableOppositeFilter;

@property (weak) NSObject <SNFAddBehaviorDelegate> *delegate;
@property (weak) IBOutlet UITableView *behaviorsTable;
@property (weak) IBOutlet UIButton *closeButton;
@property (weak) IBOutlet UIButton *addNewBehaviorButton;
@property (weak) IBOutlet UIButton *addBehaviorsButton;
@property (weak) IBOutlet UISegmentedControl *positiveNegativeSegment;
@property (nonatomic) SNFBoard *board;

- (IBAction)onBack:(UIButton *)sender;
- (IBAction)onNewBehavior:(UIButton *)sender;
- (IBAction)onAddBehaviors:(UIButton *)sender;
- (IBAction)positiveNegativeSegmentChange:(UISegmentedControl *)sender;

@end
