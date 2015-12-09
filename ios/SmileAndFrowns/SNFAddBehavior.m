
#import "SNFAddBehavior.h"
#import "SNFModel.h"
#import "UIView+LayoutHelpers.h"
#import "SNFSyncService.h"
#import "SNFBoardDetailHeader.h"

@implementation SNFAddBehavior

- (void) viewDidLoad {
	[super viewDidLoad];
	[[GATracking instance] trackScreenWithTagManager:@"AddBehaviorView"];
	[self decorate];
	
	if(self.selectNegativeOnLoad) {
		self.positiveNegativeSegment.selectedSegmentIndex = 1;
	}
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.addBehaviorsButton];
	[SNFFormStyles roundEdgesOnButton:self.addNewBehaviorButton];
	[SNFFormStyles updateFontOnSegmentControl:self.positiveNegativeSegment];
	
	self.addBehaviorsButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
	self.addBehaviorsButton.titleLabel.minimumScaleFactor = .5;
	
	self.addNewBehaviorButton.titleLabel.adjustsFontSizeToFitWidth = TRUE;
	self.addNewBehaviorButton.titleLabel.minimumScaleFactor = .5;
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateBehaviors];
	[self startBannerAd];
}

- (void)updateBehaviors{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFPredefinedBehaviorGroup"];
	NSArray *allGroups = [context executeFetchRequest:request error:&error];
	BOOL positiveSelected = !self.positiveNegativeSegment.selectedSegmentIndex;
	NSMutableArray *filteredBehaviorGroups = [[NSMutableArray alloc] init];
	for(SNFPredefinedBehaviorGroup *pdbg in allGroups){
		if(positiveSelected && pdbg.positiveBehaviors.count > 0){
			[filteredBehaviorGroups addObject:pdbg];
		}
		if(!positiveSelected && pdbg.negativeBehaviors.count > 0){
			[filteredBehaviorGroups addObject:pdbg];
		}
	}
	
	_predefinedBehaviorGroups = filteredBehaviorGroups;
	[self.behaviorsTable reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	SNFPredefinedBehaviorGroup *group = [_predefinedBehaviorGroups objectAtIndex:section];
	BOOL positiveSelected = !self.positiveNegativeSegment.selectedSegmentIndex;
	if(positiveSelected){
		return group.positiveBehaviors.count;
	}else{
		return group.negativeBehaviors.count;
	}
	return 0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return _predefinedBehaviorGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFPredefinedBehaviorGroup *group = [_predefinedBehaviorGroups objectAtIndex:indexPath.section];
	
	NSArray *behaviors;
	
	BOOL positiveSelected = !self.positiveNegativeSegment.selectedSegmentIndex;
	if(positiveSelected){
		behaviors = group.positiveBehaviors;
	}else{
		behaviors = group.negativeBehaviors;
	}

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
	SNFPredefinedBehaviorGroup * group = [_predefinedBehaviorGroups objectAtIndex:section];
	SNFBoardDetailHeader * headerCell = [[SNFBoardDetailHeader alloc] init];
	headerCell.textLabel.text = group.title;
	headerCell.textLabel.textColor = [SNFFormStyles darkGray];
	headerCell.contentView.backgroundColor = [SNFFormStyles darkSandColor];
	return headerCell;
}

- (IBAction)onBack:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (IBAction)onNewBehavior:(UIButton *)sender{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	SNFPredefinedBehaviorGroup *userGroup = [self userGroup];
	NSNumber *positive = [NSNumber numberWithBool:!self.positiveNegativeSegment.selectedSegmentIndex];
	NSDictionary *behaviorInfo = @{
									@"uuid": [[NSUUID UUID] UUIDString],
									@"title": @"Untitled",
									@"positive": positive,
									};
	SNFPredefinedBehavior *behavior = (SNFPredefinedBehavior *)[SNFPredefinedBehavior editOrCreatefromInfoDictionary:behaviorInfo withContext:context];
	[userGroup addBehaviorsObject:behavior];
	[[SNFSyncService instance] saveContext];
	_selectedBehavior = behavior;
	
	[self updateBehaviors];
	
	CGPoint offset = CGPointMake(0, self.behaviorsTable.contentSize.height - self.behaviorsTable.frame.size.height);
	[self.behaviorsTable setContentOffset:offset animated:NO];
	
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
		[[SNFSyncService instance] saveContext];
	}
	return userGroup;
}



- (IBAction)onAddBehaviors:(UIButton *)sender{
	if(!self.board || [self.board.uuid isEmpty] || !self.board.uuid){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Something went wrong.  The board does not rexist or is invalid." preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	if([self.behaviorsTable indexPathsForSelectedRows].count == 0){
		UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"You have not selected any behaviors to add to the board.  Are you sure?" preferredStyle:UIAlertControllerStyleAlert];
		[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self dismissViewControllerAnimated:YES completion:^{}];
		}]];
		[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {}]];
		[self presentViewController:alert animated:YES completion:nil];
		return;
	}
	
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	NSMutableArray *addedBehaviors = [[NSMutableArray alloc] init];
	
	
	for(NSIndexPath *indexPath in [self.behaviorsTable indexPathsForSelectedRows]){	
		SNFPredefinedBehaviorGroup *predefinedGroup = [_predefinedBehaviorGroups objectAtIndex:indexPath.section];
		NSArray *behaviors;
		BOOL positiveSelected = !self.positiveNegativeSegment.selectedSegmentIndex;
		if(positiveSelected){
			behaviors = predefinedGroup.positiveBehaviors;
		}else{
			behaviors = predefinedGroup.negativeBehaviors;
		}
		SNFPredefinedBehavior *predefinedBehavior = [behaviors objectAtIndex:indexPath.row];
		if(predefinedBehavior && self.board){
			NSDictionary *behaviorInfo = @{
										  @"title": predefinedBehavior.title,
										  @"uuid": [[NSUUID UUID] UUIDString],
										  @"positive": predefinedBehavior.positive,
										  };
			NSLog(@"adding behavior %@", predefinedBehavior.title);
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


- (IBAction)positiveNegativeSegmentChange:(UISegmentedControl *)sender{
	[self updateBehaviors];
}

@end
