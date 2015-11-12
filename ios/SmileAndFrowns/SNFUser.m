
#import "SNFUser.h"
#import "SNFUserRole.h"

@implementation SNFUser

+ (NSString *)primaryLookup{
	return @"username";
}

+ (NSDictionary *)keyMappings{
	return @{
		@"username": @"username",
		@"first_name": @"first_name",
		@"last_name": @"last_name",
		@"email":@"email",
		@"age": @"age",
		@"gender": @"gender",
		@"remote_id": @"id",
	};
}

- (void)awakeFromInsert{
	if(!self.username){
		self.username = [[NSUUID UUID] UUIDString];
	}
	if(!self.first_name){
		self.first_name = @"";
	}
	if(!self.last_name){
		self.last_name = @"";
	}
	if(!self.gender){
		self.gender = @"";
	}
	if(!self.age){
		self.age = [NSNumber numberWithInt:0];
	}
	[super awakeFromInsert];
}

- (void)updateUserRolesForSyncWithContext:(NSManagedObjectContext *)context{
	NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SNFUserRole"];
	fetchRequest.predicate = [NSPredicate predicateWithFormat:@"(user=%@)", self];
	NSError *error;
	NSArray *results = [context executeFetchRequest:fetchRequest error:&error];
	if(error){
		NSLog(@"could not find user roles:\n %@", error.localizedDescription);
	}
	for(SNFUserRole *userRole in results){
		userRole.updated_date = [NSDate date];
	}
}


- (void)updateProfileImage:(UIImage *)image{
	const CGSize size = CGSizeMake(300.0, 300.0);
	UIImage *newImage = [image imageCroppedFromSize:size];
	NSData *jpgData = UIImageJPEGRepresentation(newImage, 8);
	NSString *fileName = [NSString stringWithFormat:@"%@.jpg", [[NSUUID UUID] UUIDString]];
	NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	NSString *fullPath = [docsPath stringByAppendingPathComponent:fileName];
	[jpgData writeToFile:fullPath atomically:YES];
	self.image = fileName;
}

- (UIImage *)localImage{
	NSString *docsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
	NSString *fullPath = [docsPath stringByAppendingPathComponent:self.image];
	return [UIImage imageWithContentsOfFile:fullPath];
}

+ (NSArray *)ageSelections{
	NSMutableArray *ages = [[NSMutableArray alloc] init];
	for(NSInteger i=SNFUserAgeMin; i<SNFUserAgeMax; i++){
		[ages addObject:[NSString stringWithFormat:@"%lu", i]];
	}
	return [NSArray arrayWithArray:ages];
}

+ (NSArray *)genderSelections{
	return @[@"---------", @"Male", @"Female"];
}


@end
