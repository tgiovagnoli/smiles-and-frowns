
#import "SNFBoardDetailChildCell.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "UIImageView+DiskCache.h"
#import "UIView+LayoutHelpers.h"
#import "NSString+Additions.h"
#import "NSTimer+Blocks.h"

@implementation SNFBoardDetailChildCell

- (void) awakeFromNib {
//	self.containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.containerView.layer.shadowOffset = CGSizeMake(0, 0);
//	self.containerView.layer.shadowOpacity = .2;
//	self.containerView.layer.shadowRadius = 1;
	
	self.containerView.layer.borderWidth = 2;
	self.containerView.layer.borderColor = [[UIColor whiteColor] CGColor];
	
//	self.smileImage.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.smileImage.layer.shadowOffset = CGSizeMake(0,2);
//	self.smileImage.layer.shadowOpacity = .2;
//	self.smileImage.layer.shadowRadius = 1;
	
//	self.frownImage.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.frownImage.layer.shadowOffset = CGSizeMake(0,2);
//	self.frownImage.layer.shadowOpacity = .2;
//	self.frownImage.layer.shadowRadius = 1;
	
//	self.spendImage.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.spendImage.layer.shadowOffset = CGSizeMake(0,0);
//	self.spendImage.layer.shadowOpacity = .2;
//	self.spendImage.layer.shadowRadius = 3;
	
	UITapGestureRecognizer * report = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReport:)];
	[self.profileImage addGestureRecognizer:report];
	
//	self.smileContainer.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.smileContainer.layer.shadowOffset = CGSizeMake(0,1);
//	self.smileContainer.layer.shadowOpacity = .2;
//	self.smileContainer.layer.shadowRadius = 1;
	
//	self.frownContainer.layer.shadowColor = [[UIColor blackColor] CGColor];
//	self.frownContainer.layer.shadowOffset = CGSizeMake(0,1);
//	self.frownContainer.layer.shadowOpacity = .2;
//	self.frownContainer.layer.shadowRadius = 1;
	
	[self updateSmileAndFrownContainers];
}

- (void) prepareForReuse {
	[self updateSmileAndFrownContainers];
}

- (void) layoutSubviews {
	[super layoutSubviews];
	[self updateSmileAndFrownContainers];
}

- (void) setUserRole:(SNFUserRole *) userRole {
	_userRole = userRole;
	[self updateUI];
}

- (void) updateUI {
	NSPredicate * snfPredacate = [NSPredicate predicateWithFormat:@"(board=%@) AND (user=%@)", _userRole.board, _userRole.user];
	
	NSFetchRequest * smileFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFSmile"];
	smileFetchRequest.resultType = NSCountResultType;
	smileFetchRequest.predicate = snfPredacate;
	NSError * smileFetchError = nil;
	NSUInteger smilesCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:smileFetchRequest error:&smileFetchError];
	
	if(smileFetchError) {
		NSLog(@"%@", smileFetchError);
	}
	
	self.smilesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smilesCount];
	
	NSFetchRequest * frownFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFFrown"];
	frownFetchRequest.resultType = NSCountResultType;
	frownFetchRequest.predicate = snfPredacate;
	NSError * frownFetchError = nil;
	if(frownFetchError) {
		NSLog(@"%@", frownFetchError);
	}
	
	NSUInteger frownsCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:frownFetchRequest error:&frownFetchError];
	self.frownsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)frownsCount];
	self.nameLabel.text = self.userRole.user.first_name;
	self.spendLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.userRole.board smileCurrencyForUser:self.userRole.user]];
	
	[self setImageFromGender];
	
	if(![self.userRole.user.image isEmpty] && self.userRole.user.image) {
		NSURL * url = [NSURL URLWithString:self.userRole.user.image];
		[self.profileImage setImageWithDefaultAuthBasicForURL:url withCompletion:^(NSError *error, UIImage *image) {
			[self.profileImage setImage:image asProfileWithBorderColor:[UIColor whiteColor] andBorderThickness:2];
			if(error) {
				[self setImageFromGender];
			}
		}];
	}
	
	[NSTimer scheduledTimerWithTimeInterval:.025 block:^{
		[self updateSmileAndFrownContainers];
	} repeats:FALSE];
}

- (void) updateSmileAndFrownContainers {
//	CGFloat width = self.spendContainer.left - self.profileContainer.right;
//	CGFloat itemWidth = self.smileContainer.width * 2;
//	CGFloat spacing = (width - itemWidth) / 4;
//	self.smileLeft.constant = self.profileContainer.right + spacing;
//	self.frownLeft.constant = self.profileContainer.right + self.smileContainer.width + spacing * 2.5;
}

- (void) setImageFromGender {
	if([self.userRole.user.gender isEqualToString:SNFUserGenderFemale]){
		self.profileImage.image = [UIImage imageNamed:@"female"];
	}else{
		self.profileImage.image = [UIImage imageNamed:@"male"];
	}
}

- (IBAction)onSmile:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToAddSmile:self forUserRole:self.userRole];
	}
}

- (IBAction)onFrown:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToAddFrown:self forUserRole:self.userRole];
	}
}

- (IBAction)onSpend:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToSpend:self forUserRole:self.userRole];
	}
}

- (void)onReport:(UITapGestureRecognizer *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToOpenReport:self forUserRole:self.userRole];
	}
}

- (IBAction)onDelete:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToDelete:self forUserRole:self.userRole];
	}
}

- (IBAction)onEdit:(UIButton *)sender{
	if(self.delegate){
		[self.delegate childCellWantsToEdit:self forUserRole:self.userRole];
	}
}

@end
