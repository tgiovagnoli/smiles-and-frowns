
#import "SNFBoardDetailChildCell.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "UIImageView+LocalCache.h"
#import "UIView+LayoutHelpers.h"

@implementation SNFBoardDetailChildCell

- (void)setUserRole:(SNFUserRole *)userRole{
	_userRole = userRole;
	UITapGestureRecognizer *gr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onReport:)];
	[self.profileImage addGestureRecognizer:gr];
	[self updateUI];
}

- (void)updateUI{
	NSPredicate *snfPredacate = [NSPredicate predicateWithFormat:@"(board=%@) AND (user=%@)", _userRole.board, _userRole.user];
	
	NSFetchRequest *smileFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFSmile"];
	smileFetchRequest.resultType = NSCountResultType;
	smileFetchRequest.predicate = snfPredacate;
	NSError *smileFetchError = nil;
	NSUInteger smilesCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:smileFetchRequest error:&smileFetchError];
	if(smileFetchError){
		NSLog(@"%@", smileFetchError);
	}
	self.smilesCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)smilesCount];
	
	NSFetchRequest *frownFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFFrown"];
	frownFetchRequest.resultType = NSCountResultType;
	frownFetchRequest.predicate = snfPredacate;
	NSError *frownFetchError = nil;
	if(frownFetchError){
		NSLog(@"%@", frownFetchError);
	}
	NSUInteger frownsCount = [[SNFModel sharedInstance].managedObjectContext countForFetchRequest:frownFetchRequest error:&frownFetchError];
	self.frownsCountLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)frownsCount];
	
	self.nameLabel.text = self.userRole.user.first_name;
	self.spendLabel.text = [NSString stringWithFormat:@"%ld", (long)[self.userRole.board smileCurrencyForUser:self.userRole.user]];
	
	if(self.userRole.user.image) {
		
		NSURL * url = [NSURL URLWithString:self.userRole.user.image];
		[self.profileImage setImageForURL:url withCompletion:^(NSError *error, UIImage *image) {
			if(error) {
				[self setImageFromGender];
			}
		}];
		
	} else {
		[self setImageFromGender];
	}
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
