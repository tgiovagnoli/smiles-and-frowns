
#import "SNFBoardDetailChildCell.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "UIImageLoader.h"
#import "UIView+LayoutHelpers.h"
#import "NSString+Additions.h"
#import "NSTimer+Blocks.h"

@implementation SNFBoardDetailChildCell

- (void) awakeFromNib {
	self.containerView.layer.borderWidth = 2;
	self.containerView.layer.borderColor = [[UIColor whiteColor] CGColor];
	
	UITapGestureRecognizer * report = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReport:)];
	[self.profileImage addGestureRecognizer:report];
	
	self.profileImage.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.profileImage.layer.shadowOffset = CGSizeMake(0,2);
	self.profileImage.layer.shadowOpacity = .2;
	self.profileImage.layer.shadowRadius = 1;
	
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
	NSPredicate * smilePredacate = [NSPredicate predicateWithFormat:@"(board=%@) AND (user=%@) AND (soft_deleted=0) AND (collected=0)", _userRole.board, _userRole.user];
	NSFetchRequest * smileFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFSmile"];
	smileFetchRequest.resultType = NSCountResultType;
	smileFetchRequest.predicate = smilePredacate;
	NSError * smileFetchError = nil;
	NSUInteger smilesCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:smileFetchRequest error:&smileFetchError];
	if(smileFetchError) {
		NSLog(@"%@", smileFetchError);
	}
	self.smilesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smilesCount];
	
	NSPredicate * frownPredacate = [NSPredicate predicateWithFormat:@"(board=%@) AND (user=%@) AND (soft_deleted=0)", _userRole.board, _userRole.user];
	NSFetchRequest * frownFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFFrown"];
	frownFetchRequest.resultType = NSCountResultType;
	frownFetchRequest.predicate = frownPredacate;
	NSError * frownFetchError = nil;
	if(frownFetchError) {
		NSLog(@"%@", frownFetchError);
	}
	NSUInteger frownsCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:frownFetchRequest error:&frownFetchError];
	self.frownsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)frownsCount];
	self.nameLabel.text = self.userRole.user.first_name;
	
	//	NSPredicate * spendSmilePredicate = [NSPredicate predicateWithFormat:@"(board=%@) AND (user=%@) AND (soft_deleted=0) AND (collected=0)", _userRole.board, _userRole.user];
	//	NSFetchRequest * spendSmileFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFSpendableSmile"];
	//	spendSmileFetchRequest.resultType = NSCountResultType;
	//	spendSmileFetchRequest.predicate = spendSmilePredicate;
	//	NSError * spendSmileFetchError = nil;
	//	NSUInteger spendSmilesCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:spendSmileFetchRequest error:&spendSmileFetchError];
	//	if(spendSmileFetchError) {
	//		NSLog(@"%@", spendSmileFetchError);
	//	}
	//	self.spendLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)spendSmilesCount];
	NSInteger spendable = [self.userRole.board spendableSmilesForUser:self.userRole.user includeDeletedSmiles:FALSE includeCollectedSmiles:FALSE].count;
	self.spendLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)spendable];
	//self.spendLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.userRole.board smileCurrencyForUser:self.userRole.user]];
	
	//if(frownsCount > smilesCount) {
	//	self.spendLabel.text = [NSString stringWithFormat:@"-%lu",frownsCount-smilesCount];
	//}
	
	[self setImageFromGender];
	
	if(![self.userRole.user.image isEmpty] && self.userRole.user.image) {
		NSURL * url = [NSURL URLWithString:self.userRole.user.image];
		[[UIImageLoader defaultLoader] loadImageWithURL:url hasCache:^(UIImageLoaderImage *image, UIImageLoadSource loadedFromSource) {
			[self.profileImage setImage:image asProfileWithBorderColor:[UIColor whiteColor] andBorderThickness:2];
		} sendingRequest:^(BOOL didHaveCachedImage) {
		} requestCompleted:^(NSError *error, UIImageLoaderImage *image, UIImageLoadSource loadedFromSource) {
			if(loadedFromSource == UIImageLoadSourceNetworkToDisk) {
				[self.profileImage setImage:image asProfileWithBorderColor:[UIColor whiteColor] andBorderThickness:2];
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

- (IBAction) onReset:(id)sender {
	if(self.delegate){
		[self.delegate childCellWantsToReset:self forUserRole:self.userRole];
	}
}

- (void) setIsLastCell:(BOOL) isLastCell {
	_isLastCell = isLastCell;
	if(isLastCell) {
		self.bottomSpacing.constant = 4;
		//self.spendCenterY.constant = 0;
	} else {
		self.bottomSpacing.constant = 0;
		//self.spendCenterY.constant = -9.5;
	}
}

@end
