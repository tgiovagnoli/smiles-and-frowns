
#import <UIKit/UIKit.h>
#import "SNFSwipeCell.h"

extern NSString * const SNFInvitesCellDelete;

@interface SNFInvitesCell : SNFSwipeCell

@property NSString * inviteCode;
@property (weak) IBOutlet UILabel * titleLabel;
@property (weak) IBOutlet UILabel * dateLabel;

@end
