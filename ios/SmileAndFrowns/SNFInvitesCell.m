
#import "SNFInvitesCell.h"

NSString * const SNFInvitesCellDelete = @"SNFInvitesCellDelete";

@implementation SNFInvitesCell

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	self.layoutMargins = UIEdgeInsetsZero;
	self.contentView.layoutMargins = UIEdgeInsetsZero;
	return self;
}

- (IBAction) onDelete:(id)sender {
	NSDictionary * info = @{@"code":self.inviteCode};
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFInvitesCellDelete object:nil userInfo:info];
}

@end
