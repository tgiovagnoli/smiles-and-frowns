#import "SNFBoard.h"
#import "SNFBehavior.h"
#import "SNFSmile.h"

@implementation SNFBoard

+ (NSDictionary *)keyMappings{
	return @{
		@"uuid": @"uuid",
		@"title": @"title",
		@"deleted": @"deleted",
		@"transaction_id": @"transaction_id",
		@"remote_id": @"id",
		@"updated_date": @"updated_date",
		@"created_date": @"created_date",
		@"edit_count": @"edit_count",
		@"sync_date": @"sync_date",
		@"owner": @"owner"
	};
}

- (void) awakeFromInsert{
	[self setValue:[NSDate date] forKey:@"updated_date"];
	[self setValue:[NSDate date] forKey:@"created_date"];
	[self setValue:[NSDate date] forKey:@"sync_date"];
	[super awakeFromInsert];
}


- (NSDictionary *)infoDictionary{
	NSDictionary *dict = [super infoDictionary];
	NSMutableDictionary *extras = [[NSMutableDictionary alloc] initWithDictionary:dict];
	[extras setObject:[self stringFromDate:self.updated_date] forKey:@"device_date"];
	return [NSDictionary dictionaryWithDictionary:extras];
}

- (NSDictionary *)infoDictionaryWithChildrenAsUIDs{
	NSDictionary *dict = [super infoDictionaryWithChildrenAsUIDs];
	NSMutableDictionary *extras = [[NSMutableDictionary alloc] initWithDictionary:dict];
	[extras setObject:[self stringFromDate:self.updated_date] forKey:@"device_date"];
	return [NSDictionary dictionaryWithDictionary:extras];
}

+ (NSArray *)boardsSinceSyncDate:(NSDate *)syncDate withContext:(NSManagedObjectContext *)context{
	NSError *error;
	NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"SNFBoard"];
	request.predicate = [NSPredicate predicateWithFormat:@"updated_date > %@", syncDate];
	return [context executeFetchRequest:request error:&error];
}

@end
