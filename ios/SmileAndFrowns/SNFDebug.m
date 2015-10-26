#import "SNFDebug.h"
#import "SNFModel.h"
#import "SNFBoard.h"
#import "SNFFrown.h"
#import "SNFSmile.h"

@implementation SNFDebug

- (void)viewDidLoad {
    [super viewDidLoad];
	[self insertItemWithName:@"Check Dictionaries" andSelector:@selector(checkDictionaries)];
}

- (void)checkDictionaries{
	NSDictionary *boardInfo = @{
								@"updated_date": @"2015-10-21T21:20:38Z",
								@"edit_count": @(1),
								@"uuid": @"8b2db382-7839-11e5-8bcf-feff819cdc9f",
								@"title": @"Custom Board",
								@"deleted": @(NO),
								@"device_date": @"2015-10-21T21:20:38Z",
								@"created_date": @"2015-10-21T21:20:38Z",
								@"id": @(1)
								};
	SNFBoard *board = (SNFBoard *)[SNFBoard editOrCreatefromInfoDictionary:boardInfo];
	NSDictionary *boardInfoDict = [board infoDictionary];
	
	NSDictionary *frownInfo = @{
								@"updated_date": @"2015-10-21T21:20:38Z",
								@"uuid": @"8b2db382-7839-11e5-8bcf-feff819cdc9f",
								@"deleted": @(NO),
								@"device_date": @"2015-10-21T21:20:38Z",
								@"created_date": @"2015-10-21T21:20:38Z",
								@"id": @(1),
								@"board": @{
											@"uuid": @"8b2db382-7839-11e5-8bcf-feff819cdc9f",
										}
								};
	SNFFrown *frown = (SNFFrown *)[SNFFrown editOrCreatefromInfoDictionary:frownInfo];
	
	NSDictionary *smileInfo = @{
								@"updated_date": @"2015-10-21T21:20:38Z",
								@"uuid": @"8b2db382-7839-11e5-8bcf-feff819cdc9f",
								@"deleted": @(NO),
								@"device_date": @"2015-10-21T21:20:38Z",
								@"created_date": @"2015-10-21T21:20:38Z",
								@"id": @(1),
								@"board": @{
										@"uuid": @"8b2db382-7839-11e5-8bcf-feff819cdc9f",
										}
								};
	SNFSmile *smile = (SNFSmile *)[SNFSmile editOrCreatefromInfoDictionary:smileInfo];
	// NSDictionary *frownInfo = [frown infoDictionary];
	NSLog(@"%@", smile.board);
}


@end
