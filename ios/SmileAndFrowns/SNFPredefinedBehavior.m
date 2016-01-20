#import "SNFPredefinedBehavior.h"
#import "SNFPredefinedBoard.h"
#import "SNFPredefinedBehaviorGroup.h"
#import "SNFModel.h"

@implementation SNFPredefinedBehavior

+ (NSDictionary *) keyMappings {
	return @{
		@"uuid": @"uuid",
		@"title": @"title",
		@"positive": @"positive",
		@"group":@"group",
		@"soft_delete":@"soft_delete",
	};
}

+ (SNFPredefinedBehavior *) behaviorByUUID:(NSString *) uuid; {
	NSError * error = nil;
	NSFetchRequest * findRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * findEntity = [NSEntityDescription entityForName:@"SNFPredefinedBehavior" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
	[findRequest setEntity:findEntity];
	[findRequest setPredicate:[NSPredicate predicateWithFormat:@"uuid=%@", uuid]];
	NSArray * fetchedObjects = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:findRequest error:&error];
	if(error) {
		NSLog(@"fetch boardByUUID error: %@",error);
		return nil;
	}
	if(fetchedObjects.count > 0) {
		return [fetchedObjects objectAtIndex:0];
	}
	return nil;
}

+ (SNFPredefinedBehaviorGroup *) groupForBehavior:(SNFPredefinedBehavior *) behavior {
	NSError * error = nil;
	NSFetchRequest * findRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * findEntity = [NSEntityDescription entityForName:@"SNFPredefinedBehaviorGroup" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
	[findRequest setEntity:findEntity];
	[findRequest setPredicate:[NSPredicate predicateWithFormat:@"ANY behaviors.uuid =[c] %@", behavior.uuid]];
	NSArray * fetchedObjects = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:findRequest error:&error];
	if(error) {
		NSLog(@"fetch boardByUUID error: %@",error);
		return nil;
	}
	if(fetchedObjects.count > 0) {
		return [fetchedObjects objectAtIndex:0];
	}
	return nil;
}

@end
