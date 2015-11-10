
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ModalCreation.h"
#import "SNFBoardEdit.h"

@implementation SNFBoardDetail

- (void) viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserRoleAddedChild:) name:SNFAddUserRoleAddedChild object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBoardEditFinished:) name:SNFBoardEditFinished object:nil];
	[self updateUI];
}

- (void) dealloc {
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void) onBoardEditFinished:(NSNotification *) note {
	self.titleLabel.text = self.board.title;
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
}

- (void)updateUI{
	self.titleLabel.text = self.board.title;
	[self reloadUserRoles];
}

- (void) onUserRoleAddedChild:(NSNotification *) note {
	[self reloadUserRoles];
	[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	UITableViewHeaderFooterView *headerCell = [[UITableViewHeaderFooterView alloc] init];
	switch ((SNFBoardDetailUserRole)section) {
		case SNFBoardDetailUserRoleOwner:
			headerCell.textLabel.text = @"Owner";
			break;
		case SNFBoardDetailUserRoleChildren:
			headerCell.textLabel.text = @"Children";
			break;
		case SNFBoardDetailUserRoleParents:
			headerCell.textLabel.text = @"Parents";
			break;
		case SNFBoardDetailUserRoleGuardians:
			headerCell.textLabel.text = @"Guardians";
			break;
	}
	return headerCell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
	BOOL showHeader = NO;
	switch ((SNFBoardDetailUserRole)section) {
		case SNFBoardDetailUserRoleOwner:
			showHeader = YES;
			break;
		case SNFBoardDetailUserRoleChildren:
			showHeader = _children.count > 0;
			break;
		case SNFBoardDetailUserRoleParents:
			showHeader = _parents.count > 0;
			break;
		case SNFBoardDetailUserRoleGuardians:
			showHeader = _guardians.count > 0;
			break;
	}
	if(showHeader){
		return 20.0;
	}
	return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch ((SNFBoardDetailUserRole)section) {
		case SNFBoardDetailUserRoleOwner:
			return 1;
			break;
		case SNFBoardDetailUserRoleChildren:
			return _children.count;
			break;
		case SNFBoardDetailUserRoleParents:
			return _parents.count;
			break;
		case SNFBoardDetailUserRoleGuardians:
			return _guardians.count;
			break;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFUserRole *userRole;
	switch ((SNFBoardDetailUserRole)indexPath.section) {
		case SNFBoardDetailUserRoleOwner:
			return [self adultCellForUser:self.board.owner];
			break;
		case SNFBoardDetailUserRoleChildren:
			userRole = [_children objectAtIndex:indexPath.row];
			return [self childCellForUserRole:userRole];
			break;
		case SNFBoardDetailUserRoleParents:
			userRole = [_parents objectAtIndex:indexPath.row];
			return [self adultCellForUser:userRole.user];
			break;
		case SNFBoardDetailUserRoleGuardians:
			userRole = [_guardians objectAtIndex:indexPath.row];
			return [self adultCellForUser:userRole.user];
			break;
	}
	return nil;
}

- (SNFBoardDetailAdultCell *)adultCellForUser:(SNFUser *)user{
	SNFBoardDetailAdultCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailAdultCell"];
	if(!cell){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailAdultCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	cell.user = user;
	return cell;
}

- (SNFBoardDetailChildCell *)childCellForUserRole:(SNFUserRole *)userRole{
	SNFBoardDetailChildCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailChildCell"];
	if(!cell){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailChildCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	cell.delegate = self;
	cell.userRole = userRole;
	return cell;
}

- (IBAction)onAddUserRole:(id)sender{
	SNFAddUserRole * addUserRole = [[SNFAddUserRole alloc] initWithSourceView:self.addButton sourceRect:CGRectZero contentSize:CGSizeMake(500,400)];
	addUserRole.board = self.board;
	[[AppDelegate rootViewController] presentViewController:addUserRole animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 90;
}

- (void)childCellWantsToAddSmile:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	[self addSNFFortype:SNFAddSmileOrFrownTypeSmile andUserRole:userRole cell:cell];
}

- (void)childCellWantsToAddFrown:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	[self addSNFFortype:SNFAddSmileOrFrownTypeFrown andUserRole:userRole cell:cell];
}

- (void)addSNFFortype:(SNFAddSmileOrFrownType)type andUserRole:(SNFUserRole *)userRole cell:(SNFBoardDetailChildCell *) cell {
	SNFAddSmileOrFrown *addModal = nil;
	
	if(type == SNFAddSmileOrFrownTypeSmile) {
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell sourceRect:cell.smileButton.frame contentSize:CGSizeMake(500,600)];
	} else {
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell sourceRect:cell.frownButton.frame contentSize:CGSizeMake(500,600)];
	}
	
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
	SNFSpendRewards * rewards = [[SNFSpendRewards alloc] initWithSourceView:cell sourceRect:cell.spendButton.frame contentSize:CGSizeMake(500,490)];
	rewards.board = self.board;
	rewards.user = userRole.user;
	rewards.delegate = self;
	[[AppDelegate rootViewController] presentViewController:rewards animated:YES completion:^{}];
}

- (void)childCellWantsToOpenReport:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	SNFReporting *reporting = [[SNFReporting alloc] initWithSourceView:cell sourceRect:cell.reportingButton.frame contentSize:CGSizeMake(600,700)];
	reporting.board = userRole.board;
	reporting.user = userRole.user;
	[[AppDelegate rootViewController] presentViewController:reporting animated:YES completion:^{}];
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
	_children = [self resultsForRole:SNFUserRoleChild];
	_parents = [self resultsForRole:SNFUserRoleParent];
	_guardians = [self resultsForRole:SNFUserRoleGuardian];
	[self.rolesTable reloadData];
}

- (NSArray *)resultsForRole:(NSString *)role{
	NSSortDescriptor *userDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.user.first_name" ascending:YES];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"role==%@", role];
	NSSet *results = [_board.user_roles filteredSetUsingPredicate:predicate];
	return [results sortedArrayUsingDescriptors:@[userDescriptor]];
}


@end
