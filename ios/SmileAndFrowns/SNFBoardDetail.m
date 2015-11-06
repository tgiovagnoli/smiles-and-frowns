
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ModalCreation.h"

@implementation SNFBoardDetail

- (void) viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserRoleAddedChild:) name:SNFAddUserRoleAddedChild object:nil];
	[self updateUI];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (void)updateUI{
	self.titleLabel.text = self.board.title;
	[self reloadUserRoles];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onUserRoleAddedChild:(NSNotification *) note {
	[self reloadUserRoles];
	[self dismissViewControllerAnimated:TRUE completion:nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _userRoles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFUserRole *userRole = [_userRoles objectAtIndex:indexPath.row];
	if([userRole.role isEqualToString:SNFUserRoleChild]){
		SNFBoardDetailChildCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailChildCell"];
		if(!cell){
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailChildCell" owner:self options:nil];
			cell = [topLevelObjects firstObject];
		}
		cell.delegate = self;
		cell.userRole = userRole;
		return cell;
	}else{
		SNFBoardDetailAdultCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailAdultCell"];
		if(!cell){
			NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailAdultCell" owner:self options:nil];
			cell = [topLevelObjects firstObject];
		}
		cell.userRole = userRole;
		return cell;
	}
	return nil;
}

- (IBAction)onAddUserRole:(id)sender{
	SNFAddUserRole * addUserRole = [[SNFAddUserRole alloc] initWithSourceView:self.addButton sourceRect:CGRectZero contentSize:CGSizeMake(500,600)];
	addUserRole.board = self.board;
	[self presentViewController:addUserRole animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

- (void)childCellWantsToAddSmile:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	[self addSNFFortype:SNFAddSmileOrFrownTypeSmile andUserRole:userRole];
}

- (void)childCellWantsToAddFrown:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	[self addSNFFortype:SNFAddSmileOrFrownTypeFrown andUserRole:userRole];
}

- (void)addSNFFortype:(SNFAddSmileOrFrownType)type andUserRole:(SNFUserRole *)userRole{
	SNFAddSmileOrFrown *addModal = [[SNFAddSmileOrFrown alloc] init];
	addModal.type = type;
	addModal.board = self.board;
	addModal.user = userRole.user;
	addModal.delegate = self;
	[[AppDelegate rootViewController] presentViewController:addModal animated:YES completion:^{}];
}

- (void)addSmileOrFrownFinished:(SNFAddSmileOrFrown *)addSoF{
	[self reloadUserRoles];
}

- (void)childCellWantsToSpend:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	SNFSpendRewards *rewards = [[SNFSpendRewards alloc] init];
	rewards.board = self.board;
	rewards.user = userRole.user;
	rewards.delegate = self;
	[self presentViewController:rewards animated:YES completion:^{}];
}

- (void)childCellWantsToOpenReport:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	SNFReporting *reporting = [[SNFReporting alloc] init];
	reporting.board = userRole.board;
	reporting.user = userRole.user;
	[self presentViewController:reporting animated:YES completion:^{}];
}

- (void)spendRewardsIsDone:(SNFSpendRewards *)spendRewards{
	[self reloadUserRoles];
}

- (IBAction)backToBoards:(UIButton *)sender{
	[[SNFViewController instance].viewControllerStack popViewControllerAnimated:YES];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI];
}

- (void)reloadUserRoles{
	NSSortDescriptor *roleDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.role" ascending:NO];
	NSSortDescriptor *userDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.user.first_name" ascending:YES];
	_userRoles = [_board.user_roles sortedArrayUsingDescriptors:@[roleDescriptor, userDescriptor]];
	[self.rolesTable reloadData];
}


@end
