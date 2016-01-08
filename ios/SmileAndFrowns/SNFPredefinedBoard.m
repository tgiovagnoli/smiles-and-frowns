
#import "SNFPredefinedBoard.h"
#import "SNFPredefinedBehavior.h"
#import "SNFModel.h"

@implementation SNFPredefinedBoard

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"title": @"title",
		@"list_sort":@"list_sort",
	};
}

+ (SNFPredefinedBoard *) boardByUUID:(NSString *) uuid; {
	NSError * error = nil;
	NSFetchRequest * findRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * findEntity = [NSEntityDescription entityForName:@"SNFPredefinedBoard" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
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

@end
