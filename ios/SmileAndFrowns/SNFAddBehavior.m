
#import "SNFAddBehavior.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"

@implementation SNFAddBehavior

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateBehaviors];
	[self startBannerAd];
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
		cell.behaviorTitleField.userInteractionEnabled = NO;
		cell.editable = NO;
	}else{
		cell.behaviorTitleField.borderStyle = UITextBorderStyleNone;
		cell.editable = YES;
		
		cell.editButton.hidden = TRUE;
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
	
	UITableViewHeaderFooterView *headerCell = [[UITableViewHeaderFooterView alloc] init];
	headerCell.textLabel.text = group.title;
	return headerCell;
	
	//UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, self.behaviorsTable.width,40)];
	//label.backgroundColor = [UIColor colorWithRed:0.89 green:0.89 blue:0.89 alpha:1];
	//label.x = 20;
	//label.text = group.title;
	//return label;
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
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSMutableArray *addedBehaviors = [[NSMutableArray alloc] init];
	for(NSIndexPath *indexPath in [self.behaviorsTable indexPathsForSelectedRows]){
		SNFPredefinedBehaviorGroup *predefinedGroup = [_predefinedBehaviorGroups objectAtIndex:indexPath.section];
		SNFPredefinedBehavior *predefinedBehavior = [[predefinedGroup.behaviors allObjects] objectAtIndex:indexPath.row];
		if(predefinedBehavior && self.board){
			NSDictionary *behaviorInfo = @{
										  @"title": predefinedBehavior.title,
										  @"uuid": [[NSUUID UUID] UUIDString]
										  };
			SNFBehavior *behavior = (SNFBehavior *)[SNFBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
			behavior.board = self.board;
			[addedBehaviors addObject:behavior];
		}
	}
	if(self.delegate){
		[self.delegate addBehavior:self addedBehaviors:addedBehaviors toBoard:self.board];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}


@end
