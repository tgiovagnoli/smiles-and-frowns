#import "SNFAddBehavior.h"
#import "SNFModel.h"

@implementation SNFAddBehavior

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateBehaviors];
}

- (void)updateBehaviors{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBehaviorGroup"];
	_predefinedBehaviorGroups = [context executeFetchRequest:request error:&error];
	[self.behaviorsTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	SNFPredefinedBehaviorGroup *group = [_predefinedBehaviorGroups objectAtIndex:section];
	return group.behaviors.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return _predefinedBehaviorGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFPredefinedBehaviorGroup *group = [_predefinedBehaviorGroups objectAtIndex:indexPath.section];
	NSArray *behaviors = [group.behaviors allObjects];
	SNFPredefinedBehavior *behavior = [behaviors objectAtIndex:indexPath.row];
	SNFAddBehaviorCell *cell = [self.behaviorsTable dequeueReusableCellWithIdentifier:@"SNFAddBehaviorCell"];
	if(!cell){
		NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFAddBehaviorCell" owner:self options:nil];
		cell = [topLevelObjects firstObject];
	}
	if([group.title isEqualToString:SNFPredefinedBehaviorGroupUserName]){
		cell.behaviorTitleField.userInteractionEnabled = YES;
	}else{
		cell.behaviorTitleField.userInteractionEnabled = NO;
	}
	cell.behavior = behavior;
	if(_selectedBehavior == cell.behavior){
		[cell.behaviorTitleField becomeFirstResponder];
		_selectedBehavior = nil;
	}
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	SNFPredefinedBehaviorGroup *group = [_predefinedBehaviorGroups objectAtIndex:section];
	UILabel *label = [[UILabel alloc] init];
	label.backgroundColor = [UIColor grayColor];
	label.text = group.title;
	return label;
}

- (IBAction)onBack:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onNewBehavior:(UIButton *)sender{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	SNFPredefinedBehaviorGroup *userGroup = [self userGroup];
	NSDictionary *behaviorInfo = @{
									@"uuid": [[NSUUID UUID] UUIDString],
									@"title": @"Untitled",
									};
	SNFPredefinedBehavior *behavior = (SNFPredefinedBehavior *)[SNFPredefinedBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
	[userGroup addBehaviorsObject:behavior];
	[context save:nil];
	_selectedBehavior = behavior;
	[self updateBehaviors];
}

- (SNFPredefinedBehaviorGroup *)userGroup{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBehaviorGroup"];
	NSArray *groups = [context executeFetchRequest:request error:&error];
	SNFPredefinedBehaviorGroup *userGroup;
	for(SNFPredefinedBehaviorGroup *group in groups){
		if([group.title isEqualToString:SNFPredefinedBehaviorGroupUserName]){
			userGroup = group;
			break;
		}
	}
	if(!userGroup){
		NSDictionary *userGroupInfo = @{
										@"uuid": [[NSUUID UUID] UUIDString],
										@"title": SNFPredefinedBehaviorGroupUserName,
										};
		userGroup = (SNFPredefinedBehaviorGroup *)[SNFPredefinedBehaviorGroup editOrCreatefromInfoDictionary:userGroupInfo withContext:context];
		[context save:nil];
	}
	return userGroup;
}


- (IBAction)onAddBehaviors:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:^{}];
}


@end
