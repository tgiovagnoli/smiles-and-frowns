#import <UIKit/UIKit.h>
#import "SNFUser.h"
#import "SNFBoard.h"
#import "SNFReportGeneration.h"
#import "SNFReportCellSmileFrown.h"
#import "SNFReportingSectionHeader.h"


typedef NS_ENUM(NSInteger, SNFReportingFilter){
	SNFReportingFilterCurrentBoard,
	SNFReportingFilterAllBoards,
};

@interface SNFReporting : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	NSArray *_reportData;
}


@property (weak) IBOutlet UILabel *titleLabel;
@property (weak) IBOutlet UIButton *backButton;
@property (weak) IBOutlet UIButton *exportButton;
@property (weak) IBOutlet UISegmentedControl *filterType;
@property (weak) IBOutlet UITableView *reportTable;

@property (nonatomic) SNFUser *user;
@property (nonatomic) SNFBoard *board;

- (IBAction)onCancel:(UIButton *)sender;

@end
