#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"

@implementation SNFBoardDetail


- (void)viewDidLoad{
	[super viewDidLoad];
	[self updateUI];
}

- (void)updateUI{
	self.titleLabel.text = self.board.title;
	[self reloadUserRoles];
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
	SNFAddUserRole *addUserRole = [[SNFAddUserRole alloc] init];
	[[AppDelegate rootViewController] presentViewController:addUserRole animated:YES completion:^{}];
	[addUserRole setBoard:self.board andCompletion:^(NSError *error, SNFUserRole *userRole) {
		[[AppDelegate rootViewController] dismissViewControllerAnimated:YES completion:^{}];
		if(userRole){
			[self reloadUserRoles];
		}
	}];
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
	
}

- (IBAction)backToBoards:(UIButton *)sender{
	[[SNFViewController instance].viewControllerStack popViewControllerAnimated:YES];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI];
}

- (void)reloadUserRoles{
	NSComparator comparisonBlock = ^(id first,id second) {
		return NSOrderedAscending;
	};
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"role" ascending:YES comparator:comparisonBlock];
	_userRoles = [_board.user_roles sortedArrayUsingDescriptors:@[descriptor]];
	[self.rolesTable reloadData];
}


@end
