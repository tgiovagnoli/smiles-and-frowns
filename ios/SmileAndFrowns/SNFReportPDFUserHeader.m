
#import "SNFReportPDFUserHeader.h"
#import "UIImageDiskCache.h"
#import "UIImageView+ProfileStyle.h"
#import "UIView+LayoutHelpers.h"

NSString * const SNFReportPDFUserHeaderImageFinished = @"SNFReportPDFUserHeaderImageFinished";

@interface SNFReportPDFUserHeader ()
@end

@implementation SNFReportPDFUserHeader

- (void) viewDidLoad {
	[super viewDidLoad];
	
	NSMutableString * userNameLabel = [[NSMutableString alloc] init];
	if(self.user.first_name) {
		[userNameLabel appendString:self.user.first_name];
	}
	
	if(self.user.last_name) {
		[userNameLabel appendFormat:@" "];
		[userNameLabel appendString:self.user.last_name];
	}
	
	self.userName.text = userNameLabel;
	
	if(self.board) {
		self.boardName.text = self.board.title;
	} else {
		self.boardName.text = @"";
	}
	
	self.profileImage.layer.borderColor = [[UIColor blackColor] CGColor];
	self.profileImage.layer.borderWidth = 2;
	self.profileImage.layer.cornerRadius = self.profileImage.height/2;
	self.profileImage.layer.masksToBounds = TRUE;
	
	if([self.user.gender isEqualToString:@"male"]) {
		self.profileImage.image = [UIImage imageNamed:@"Male"];
	} else if([self.user.gender isEqualToString:@"female"]) {
		self.profileImage.image = [UIImage imageNamed:@"Female"];
	}
	
	if(self.user.image) {
		[self.profileImage setImageWithURL:[NSURL URLWithString:self.user.image] completion:^(NSError *error, UIImage *image, NSURL *url, UIImageLoadSource loadedFromSource) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFReportPDFUserHeaderImageFinished object:nil];
		}];
	}
}

@end
