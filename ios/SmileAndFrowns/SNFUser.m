#import "SNFUser.h"

@implementation SNFUser


+ (NSString *)primaryLookup{
	return @"username";
}

+ (NSDictionary *)keyMappings{
	return @{
		@"username": @"username",
		@"first_name": @"first_name",
		@"last_name": @"last_name",
		@"age": @"age",
		@"gender": @"gender",
		@"remote_id": @"id",
	};
}

- (void)awakeFromInsert{
	if(!self.username){
		self.username = [[NSUUID UUID] UUIDString];
	}
	[super awakeFromInsert];
}


@end
