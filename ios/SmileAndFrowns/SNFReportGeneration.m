#import "SNFReportGeneration.h"
#import "SNFModel.h"


@implementation SNFReportGeneration

- (NSArray <SNFReportBehaviorGroup *> *)smilesFrownsReportForUser:(SNFUser *)user board:(SNFBoard *)board ascending:(BOOL)ascending{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	
	NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(board==%@) AND (user==%@)", board, user];
	if(!board){
		predicate = [NSPredicate predicateWithFormat:@"user==%@", user];
	}
	NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"created_date" ascending:ascending];
	
	
	NSFetchRequest *smileFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFSmile"];
	smileFetchRequest.predicate = predicate;
	smileFetchRequest.sortDescriptors = @[dateSort];
	NSError *smilesFetchError = nil;
	NSArray *allSmiles = [context executeFetchRequest:smileFetchRequest error:&smilesFetchError];
	if(smilesFetchError){
		NSLog(@"%@", smilesFetchError);
	}
	
	NSFetchRequest *frownFetchRequest = [[NSFetchRequest alloc] initWithEntityName:@"SNFFrown"];
	frownFetchRequest.predicate = predicate;
	frownFetchRequest.sortDescriptors = @[dateSort];
	NSError *frownFetchError = nil;
	NSArray *allFrowns = [context executeFetchRequest:frownFetchRequest error:&frownFetchError];
	if(frownFetchError){
		NSLog(@"%@", frownFetchError);
	}
	
	// sort the smiles into an days dictionary
	NSMutableArray *daysGrouped = [[NSMutableArray alloc] init];
	for(SNFSmile *smile in allSmiles){
		NSInteger daysSinceEpoch = [self dayForObjectCreatedSinceEpoch:smile];
		SNFReportDateGroup *selectedDateGroup;
		for(SNFReportDateGroup *dateGroup in daysGrouped){
			if(dateGroup.daysSinceEpoch == daysSinceEpoch){
				selectedDateGroup = dateGroup;
				break;
			}
		}
		if(!selectedDateGroup){
			selectedDateGroup = [[SNFReportDateGroup alloc] init];
			selectedDateGroup.daysSinceEpoch = daysSinceEpoch;
			selectedDateGroup.date = [[NSCalendar currentCalendar] startOfDayForDate:smile.created_date];
			[daysGrouped addObject:selectedDateGroup];
		}
		
		SNFReportBehaviorGroup *selectedBehaviorGroup;
		for(SNFReportBehaviorGroup *behaviorGroup in selectedDateGroup.behaviorGroups){
			if([behaviorGroup checkGroupViabilityOnSmile:smile]){
				selectedBehaviorGroup = behaviorGroup;
				break;
			}
		}
		if(!selectedBehaviorGroup){
			selectedBehaviorGroup = [[SNFReportBehaviorGroup alloc] init];
			[selectedBehaviorGroup createKeysFromSmile:smile];
			[selectedDateGroup.behaviorGroups addObject:selectedBehaviorGroup];
		}
		[selectedBehaviorGroup.smiles addObject:smile];
	}
	
	for(SNFFrown *frown in allFrowns){
		NSInteger daysSinceEpoch = [self dayForObjectCreatedSinceEpoch:frown];
		SNFReportDateGroup *selectedDateGroup;
		for(SNFReportDateGroup *dateGroup in daysGrouped){
			if(dateGroup.daysSinceEpoch == daysSinceEpoch){
				selectedDateGroup = dateGroup;
				break;
			}
		}
		if(!selectedDateGroup){
			selectedDateGroup = [[SNFReportDateGroup alloc] init];
			selectedDateGroup.daysSinceEpoch = daysSinceEpoch;
			[daysGrouped addObject:selectedDateGroup];
			// TODO: need to update the NSDate to the rounded day.
		}
		
		SNFReportBehaviorGroup *selectedBehaviorGroup;
		for(SNFReportBehaviorGroup *behaviorGroup in selectedDateGroup.behaviorGroups){
			if([behaviorGroup checkGroupViabilityOnFrown:frown]){
				selectedBehaviorGroup = behaviorGroup;
			}
		}
		if(!selectedBehaviorGroup){
			selectedBehaviorGroup = [[SNFReportBehaviorGroup alloc] init];
			[selectedBehaviorGroup createKeysFromFrown:frown];
			[selectedDateGroup.behaviorGroups addObject:selectedBehaviorGroup];
		}
		[selectedBehaviorGroup.frowns addObject:frown];
	}
	return daysGrouped;
}


- (NSInteger)dayForObjectCreatedSinceEpoch:(NSManagedObject *)object{
	if([object respondsToSelector:NSSelectorFromString(@"created_date")]){
		NSDate *createdDate = [object valueForKey:@"created_date"];
		
		NSCalendar *calendar = [NSCalendar currentCalendar];
		
		NSDateComponents *epochComponents = [[NSDateComponents alloc] init];
		epochComponents.year = 1970;
		epochComponents.month = 0;
		epochComponents.day = 0;
		NSDate *epochDate = [calendar dateFromComponents:epochComponents];
		
		NSDate *epochRange;
		NSDate *createdRange;
		[calendar rangeOfUnit:NSCalendarUnitDay startDate:&epochRange interval:NULL forDate:epochDate];
		[calendar rangeOfUnit:NSCalendarUnitDay startDate:&createdRange interval:NULL forDate:createdDate];
		
		NSDateComponents *difference = [calendar components:NSCalendarUnitDay fromDate:epochRange toDate:createdRange options:0];
		
		return [difference day];
	}
	return 0;
}

@end
