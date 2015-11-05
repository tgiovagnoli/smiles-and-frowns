#import <UIKit/UIKit.h>
#import "SNFReportDateGroup.h"


@interface SNFReportingSectionHeader : UITableViewHeaderFooterView

@property IBOutlet UILabel *dateLabel;
@property (nonatomic) SNFReportDateGroup *dateGroup;

@end
