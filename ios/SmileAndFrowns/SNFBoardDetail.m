
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ModalCreation.h"
#import "SNFBoardEdit.h"
#import "SNFModel.h"

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
	// check to see if we show the add user button
	NSString *userRole = [self.board permissionForUser:[SNFModel sharedInstance].loggedInUser];
	if(userRole == nil || [userRole isEqualToString:SNFUserRoleChild] || [userRole isEqualToString:SNFUserRoleGuardian]){
		self.addButtonHeightConstraint.constant = 0.0;
		self.addButton.hidden = YES;
	}else{
		self.addButtonHeightConstraint.constant = 46.0;
		self.addButton.hidden = NO;
	}
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
			return [self adultCellForUser:self.board.owner andRole:nil];
			break;
		case SNFBoardDetailUserRoleChildren:
			userRole = [_children objectAtIndex:indexPath.row];
			return [self childCellForUserRole:userRole];
			break;
		case SNFBoardDetailUserRoleParents:
			userRole = [_parents objectAtIndex:indexPath.row];
			return [self adultCellForUser:userRole.user andRole:userRole];
			break;
		case SNFBoardDetailUserRoleGuardians:
			userRole = [_guardians objectAtIndex:indexPath.row];
			return [self adultCellForUser:userRole.user andRole:userRole];
			break;
	}
	return nil;
}

- (SNFBoardDetailAdultCell *)adultCellForUser:(SNFUser *)user andRole:(SNFUserRole *)role{
	SNFBoardDetailAdultCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailAdultCell"];
	if(!cell){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailAdultCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	cell.user = user;
	cell.userRole = role;
	cell.delegate = self;
	[self updateCellForEditingWithPermissions:cell];
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
	if(!userRole){
		cell.swipeEnabled = NO;
	}else{
		[self updateCellForEditingWithPermissions:cell];
	}
	return cell;
}

- (void)updateCellForEditingWithPermissions:(SNFSwipeCell *)cell{
	NSString *permission = [self.board permissionForUser:[SNFModel sharedInstance].loggedInUser];
	if(permission == nil || [permission isEqualToString:SNFUserRoleChild] || [permission isEqualToString:SNFUserRoleGuardian]){
		cell.swipeEnabled = NO;
	}else{
		cell.swipeEnabled = YES;
	}
}

- (IBAction)onAddUserRole:(id)sender{
	SNFAddUserRole * addUserRole = [[SNFAddUserRole alloc] initWithSourceView:self.addButton sourceRect:CGRectZero contentSize:CGSizeMake(500,380)];
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
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell sourceRect:cell.smileButton.frame contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight|UIPopoverArrowDirectionDown];
	} else {
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell sourceRect:cell.frownButton.frame contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight|UIPopoverArrowDirectionDown];
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
	SNFSpendRewards * rewards = [[SNFSpendRewards alloc] initWithSourceView:cell sourceRect:cell.spendButton.frame contentSize:CGSizeMake(500,490) arrowDirections:UIPopoverArrowDirectionRight|UIPopoverArrowDirectionDown];
	rewards.board = self.board;
	rewards.user = userRole.user;
	rewards.delegate = self;
	[[AppDelegate rootViewController] presentViewController:rewards animated:YES completion:^{}];
}

- (void)childCellWantsToOpenReport:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	NSString *permission = [self.board permissionForUser:[SNFModel sharedInstance].loggedInUser];
	if(permission == nil || [permission isEqualToString:SNFUserRoleChild] || [permission isEqualToString:SNFUserRoleGuardian]){
		return;
	}
	
	SNFReporting *reporting = [[SNFReporting alloc] initWithSourceView:cell sourceRect:cell.profileImage.frame contentSize:CGSizeMake(600,700) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionDown];
	reporting.board = userRole.board;
	reporting.user = userRole.user;
	[[AppDelegate rootViewController] presentViewController:reporting animated:YES completion:^{}];
}

- (void)childCellWantsToDelete:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Person?" message:@"Are you sure you want to delete this person? All board data for this person will be lost and this cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		userRole.soft_deleted = @(YES);
		[[SNFSyncService instance] saveContext];
		[self reloadUserRoles];
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)adultCell:(SNFBoardDetailAdultCell *)cell wantsToRemoveUserRole:(SNFUserRole *)userRole{
	// check if it's the logged in user
	if([userRole.user.username isEqualToString:[SNFModel sharedInstance].loggedInUser.username]){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Remove Yourself?" message:@"Are you sure you want to remove yourself from this board?  You will no longer be able to edit this board unless someone reinvites you." preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Remove" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			userRole.soft_deleted = @(YES);
			[[SNFSyncService instance] saveContext];
			[self reloadUserRoles];
		}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
		[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
	}else{
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Delete Person?" message:@"Are you sure you want to delete this person? All board data for this person will be lost and this cannot be undone." preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
			userRole.soft_deleted = @(YES);
			[[SNFSyncService instance] saveContext];
			[self reloadUserRoles];
		}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
		[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
	}
}

- (void)childCellWantsToEdit:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	SNFChildEdit *childEdit = [[SNFChildEdit alloc] initWithSourceView:cell sourceRect:CGRectZero contentSize:CGSizeMake(400,380) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
	childEdit.childUser = userRole.user;
	childEdit.delegate = self;
	[[AppDelegate rootViewController] presentViewController:childEdit animated:YES completion:nil];
}

- (void)childEditCancelled:(SNFChildEdit *)childEdit{
	[self reloadUserRoles];
}

- (void)childEdit:(SNFChildEdit *)childEdit editedChild:(SNFUser *)child{
	[self reloadUserRoles];
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
	NSLog(@"%@", _board.user_roles);
	for(SNFUserRole *userRole in _board.user_roles){
		NSLog(@"%@", userRole.user.first_name);
	}
	
	NSSortDescriptor *userDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"self.user.first_name" ascending:YES];
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"role==%@", role];
	NSSet *results = [_board.user_roles filteredSetUsingPredicate:predicate];
	NSMutableArray *finalResults = [[NSMutableArray alloc] init];
	for(SNFUserRole *role in results){
		if(![role.soft_deleted boolValue]){
			[finalResults addObject:role];
		}
	}
	return [finalResults sortedArrayUsingDescriptors:@[userDescriptor]];
}


@end
