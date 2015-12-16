
#import <UIKit/UIKit.h>
#import "SNFUser.h"
#import "SNFBoard.h"

extern NSString * const SNFReportPDFUserHeaderImageFinished;

@interface SNFReportPDFUserHeader : UIViewController

@property (weak) IBOutlet UIImageView * profileImage;
@property (weak) IBOutlet UILabel * boardName;
@property (weak) IBOutlet UILabel * userName;

@property SNFUser * user;
@property SNFBoard * board;

@end
