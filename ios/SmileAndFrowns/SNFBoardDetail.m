
#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "UIViewController+ModalCreation.h"
#import "SNFBoardEdit.h"
#import "SNFModel.h"
#import "SNFBoardDetailHeader.h"
#import "TriangleView.h"

@interface SNFBoardDetail ()
@property NSMutableArray * rowColors;
@end

@implementation SNFBoardDetail

- (void) viewDidLoad {
	[super viewDidLoad];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onUserRoleAddedChild:) name:SNFAddUserRoleAddedChild object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onBoardEditFinished:) name:SNFBoardEditFinished object:nil];
	
	self.addButton.layer.shadowColor = [[UIColor colorWithRed:0.743 green:0.678 blue:0.61 alpha:1] CGColor];
	self.addButton.layer.shadowOffset = CGSizeMake(0,1);
	self.addButton.layer.shadowOpacity = .1;
	self.addButton.layer.shadowRadius = 1;
	
	self.triangleView.arrowDirection = TriangleViewArrowDirectionUp;
	
	self.messageView.layer.shadowColor = [[UIColor blackColor] CGColor];
	self.messageView.layer.shadowOffset = CGSizeMake(0,1);
	self.messageView.layer.shadowOpacity = .2;
	self.messageView.layer.shadowRadius = 1;
	
	[self updateUI];
	
	self.refresh = [[UIRefreshControl alloc] init];
	[self.refresh addTarget:self action:@selector(onRefresh:) forControlEvents:UIControlEventValueChanged];
	[self.rolesTable addSubview:self.refresh];
}

- (void) onRefresh:(id) sender {
	[self.refresh beginRefreshing];
	SNFSyncService * sync = [[SNFSyncService alloc] init];
	if(!sync.syncing) {
		[sync syncWithCompletion:^(NSError *error, NSObject *boardData) {
			if(error) {
				[self.refresh endRefreshing];
				if(error.code == -1009) {
					[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
				} else {
					[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
				}
				return;
			}
			
			[sync syncPredefinedBoardsWithCompletion:^(NSError *error, NSObject *boardData) {
				[self.refresh endRefreshing];
				if(error) {
					if(error.code == -1009) {
						[self displayOKAlertWithTitle:@"Error" message:@"This feature requires an internet connection. Please try again when you’re back online." completion:nil];
					} else {
						[self displayOKAlertWithTitle:@"Error" message:error.localizedDescription completion:nil];
					}
					return;
				}
				
				[self reloadUserRoles];
			}];
		}];
	}
}

- (void) resetColors {
	self.rowColors = [NSMutableArray arrayWithArray:@[
		[UIColor colorWithRed:0.341 green:0.841 blue:0.771 alpha:1],
		[UIColor colorWithRed:0.141 green:0.58 blue:0.841 alpha:1],
		[UIColor colorWithRed:0.641 green:0.353 blue:0.592 alpha:1],
		[UIColor colorWithRed:0.969 green:0.571 blue:0.284 alpha:1],
		[UIColor colorWithRed:0.553 green:0.824 blue:0.458 alpha:1]
	]];
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
	SNFBoardDetailHeader * headerCell = [[SNFBoardDetailHeader alloc] init];
	
	switch ((SNFBoardDetailUserRole)section) {
		case SNFBoardDetailUserRoleOwner:
			headerCell.textLabel.text = @"Board Creator";
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
	
	if(showHeader) {
		return 28.0;
	}
	
	return 0.0;
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *) tableView{
	return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	switch ((SNFBoardDetailUserRole)section) {
		case SNFBoardDetailUserRoleOwner:
			return 1;
			break;
		case SNFBoardDetailUserRoleChildren:
			[self resetColors];
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
			return [self childCellForUserRole:userRole atIndexPath:indexPath];
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
	
	if(!role) {
		cell.swipeEnabled = NO;
	} else {
		[self updateCellForEditingWithPermissions:cell];
	}
	
	return cell;
}

- (SNFBoardDetailChildCell *) childCellForUserRole:(SNFUserRole *) userRole atIndexPath:(NSIndexPath *) indexPath {
	SNFBoardDetailChildCell *cell = [self.rolesTable dequeueReusableCellWithIdentifier:@"SNFBoardDetailChildCell"];
	
	if(!cell) {
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFBoardDetailChildCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	
	cell.delegate = self;
	cell.userRole = userRole;
	cell.isLastCell = FALSE;
	
	if(indexPath.row == _children.count - 1) {
		cell.isLastCell = TRUE;
	}
	
	float mod = indexPath.row % 5;
	UIColor * color = [self.rowColors objectAtIndex:(int)mod];
	
	cell.containerView.backgroundColor = color;
	
	CGRect frame = cell.frame;
	frame.size.width = self.rolesTable.width;
	cell.frame = frame;
	
	[self updateCellForEditingWithPermissions:cell];
	
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
	
	[self.messageView removeFromSuperview];
	
	SNFAddUserRole * addUserRole = [[SNFAddUserRole alloc] initWithSourceView:self.addButton sourceRect:CGRectZero contentSize:CGSizeMake(500,360)];
	addUserRole.board = self.board;
	[[AppDelegate rootViewController] presentViewController:addUserRole animated:YES completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 86;
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
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell.smileButton.superview sourceRect:cell.smileButton.frame contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
	} else {
		addModal = [[SNFAddSmileOrFrown alloc] initWithSourceView:cell.frownButton.superview sourceRect:cell.frownButton.frame contentSize:CGSizeMake(500,600) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
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
	if([cell.spendLabel.text floatValue] < 0) {
		[self displayOKAlertWithTitle:@"Sorry" message:@"Your smile count is negative. You must have a positive smile count in order to spend smiles." completion:nil];
		return;
	}
	
	SNFSpendRewards * rewards = [[SNFSpendRewards alloc] initWithSourceView:cell.spendButton.superview sourceRect:cell.spendButton.frame contentSize:CGSizeMake(500,630) arrowDirections:UIPopoverArrowDirectionRight|UIPopoverArrowDirectionDown];
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
	
	SNFReporting *reporting = [[SNFReporting alloc] initWithSourceView:cell.profileImage.superview sourceRect:cell.profileImage.frame contentSize:CGSizeMake(600,700) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionDown];
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
	SNFChildEdit *childEdit = [[SNFChildEdit alloc] initWithSourceView:cell.editButton sourceRect:CGRectZero contentSize:CGSizeMake(400,380) arrowDirections:UIPopoverArrowDirectionLeft|UIPopoverArrowDirectionRight];
	childEdit.childUser = userRole.user;
	childEdit.delegate = self;
	[[AppDelegate rootViewController] presentViewController:childEdit animated:YES completion:nil];
}

- (void) childCellWantsToReset:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole {
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Reset Frowns?" message:@"Are you sure you want to reset your smile and frown counts to 0? This will not delete your net smiles." preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Reset" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		[self resetSmilesAndFrownsForUser:userRole.user];
		[self reloadUserRoles];
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void) resetSmilesAndFrownsForUser:(SNFUser *) user {
	
	NSArray * smiles = [self.board smilesForUser:user includeDeletedSmiles:FALSE includeCollectedSmiles:FALSE];
	NSArray * frowns = [self.board frownsForUser:user includeDeletedFrowns:FALSE];
	
	for(SNFSmile * smile in smiles) {
		smile.soft_deleted = @(1);
	}
	
	for(SNFFrown * frown in frowns) {
		frown.soft_deleted = @(1);
	}
	
	[[SNFSyncService instance] saveContext];
}

- (void)childEditCancelled:(SNFChildEdit *)childEdit{
	//[self reloadUserRoles];
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
	[[GATracking instance] trackScreenWithTagManager:@"BoardDetailView"];
}

- (void)reloadUserRoles{
	_children = [self resultsForRole:SNFUserRoleChild];
	_parents = [self resultsForRole:SNFUserRoleParent];
	_guardians = [self resultsForRole:SNFUserRoleGuardian];
	
	if(_children.count > 0 || _guardians.count > 0 || _parents.count > 0) {
		[self.messageView removeFromSuperview];
	}
	
	[self.rolesTable reloadData];
}

- (NSArray *)resultsForRole:(NSString *)role{
	//NSLog(@"%@", _board.user_roles);
	//for(SNFUserRole *userRole in _board.user_roles){
	//	NSLog(@"%@", userRole.user.first_name);
	//}
	
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
