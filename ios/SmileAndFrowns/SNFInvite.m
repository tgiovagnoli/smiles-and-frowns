
#import "SNFInvite.h"
#import "SNFBoard.h"
#import "SNFModel.h"

@implementation SNFInvite

+ (NSDictionary *) keyMappings {
	return @{
		@"uuid": @"uuid",
		@"code": @"code",
		@"remote_id": @"id",
		@"board_uuid": @"board_uuid",
		@"board_title": @"board_title",
		@"sender_last_name": @"sender_last_name",
		@"sender_first_name": @"sender_first_name",
		@"created_date": @"created_date",
		@"accepted": @"accepted",
	};
}

+ (NSArray *) all; {
	NSError * error = nil;
	NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription * entity = [NSEntityDescription entityForName:@"SNFInvite" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
	[fetchRequest setEntity:entity];
	NSArray * fetchedObjects = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
	if(error) {
		NSLog(@"error making query: %@",error);
		return nil;
	}
	return fetchedObjects;
}

+ (void) deleteAllInvites {
	NSArray * all = [SNFInvite all];
	for(SNFInvite * invite in all) {
		[[SNFModel sharedInstance].managedObjectContext deleteObject:invite];
	}
	NSError * error = nil;
	[[SNFModel sharedInstance].managedObjectContext save:&error];
	if(error) {
		NSLog(@"deleteAllInvites error: %@",error);
	}
}

@end
