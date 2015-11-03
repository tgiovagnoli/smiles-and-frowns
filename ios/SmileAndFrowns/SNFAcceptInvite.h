
#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "SNFInvite.h"
#import "SNFFormViewController.h"

extern NSString * const SNFInviteAccepted;

@interface SNFAcceptInvite : SNFFormViewController

@property NSString * inviteCode;
@property SNFInvite * invite;

@property (weak) IBOutlet UILabel * joinLabel;
@property (weak) IBOutlet UITextField * inviteCodeField;

@end
