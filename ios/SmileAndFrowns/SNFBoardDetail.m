#import "SNFBoardDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"

@implementation SNFBoardDetail

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
	
}

- (void)childCellWantsToAddFrown:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	
}

- (void)childCellWantsToSpend:(SNFBoardDetailChildCell *)cell forUserRole:(SNFUserRole *)userRole{
	
}

- (IBAction)backToBoards:(UIButton *)sender{
	[[SNFViewController instance].viewControllerStack popViewControllerAnimated:YES];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self reloadUserRoles];
}

- (void)reloadUserRoles{
	NSComparator comparisonBlock = ^(id first,id second) {
		return NSOrderedAscending;
	};
	NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"role" ascending:YES comparator:comparisonBlock];
	_userRoles= [_board.user_roles sortedArrayUsingDescriptors:@[descriptor]];
	[self.rolesTable reloadData];
}


@end
