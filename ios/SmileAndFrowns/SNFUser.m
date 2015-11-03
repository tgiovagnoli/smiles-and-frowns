
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
	[super awakeFromInsert];
}


@end
