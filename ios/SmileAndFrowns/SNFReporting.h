
#import <UIKit/UIKit.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFReportGeneration.h"
#import "SNFReportCellSmileFrown.h"
#import "SNFReportingSectionHeader.h"
#import "SNFFormViewController.h"

typedef NS_ENUM(NSInteger, SNFReportingFilter){
	SNFReportingFilterThisBoardDaily,
	SNFReportingFilterThisBoardWeekly,
	SNFReportingFilterAllBoardsWeekly,
};

@interface SNFReporting : SNFFormViewController <UITableViewDataSource, UITableViewDelegate, UIPopoverControllerDelegate>

@property (weak) IBOutlet UILabel * titleLabel;
@property (weak) IBOutlet UIButton * backButton;
@property (weak) IBOutlet UIButton * exportButton;
@property (weak) IBOutlet UISegmentedControl * filterType;
@property (weak) IBOutlet UITableView * reportTable;

@property (nonatomic) SNFUser * user;
@property (nonatomic) SNFBoard * board;

- (IBAction) onCancel:(UIButton *) sender;

@end
