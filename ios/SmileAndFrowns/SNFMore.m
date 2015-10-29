#import "SNFMore.h"

@implementation SNFMore

- (void)viewDidLoad {
    [super viewDidLoad];
    _tableContents = @[
					   [self tableItemWithName:@"The Five Cs" andSelector:@selector(theFiveCs)],
					   [self tableItemWithName:@"Tips & Tricks" andSelector:@selector(tipsAndTricks)],
					   [self tableItemWithName:@"Send Feedback" andSelector:@selector(sendFeedback)],
					   [self tableItemWithName:@"Restore Purchases" andSelector:@selector(restorePurchases)],
					   [self tableItemWithName:@"Remove Ads" andSelector:@selector(removeAds)],
					   [self tableItemWithName:@"Terms and Privacy" andSelector:@selector(termsAndPrivacy)],
					   [self tableItemWithName:@"App Settings" andSelector:@selector(appSettings)],
					   [self tableItemWithName:@"Logout" andSelector:@selector(logout)],
					   ];
	[self.tableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return _tableContents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	APDDebugViewControllerItem *item = [_tableContents objectAtIndex:indexPath.row];
	cell.textLabel.text = item.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	APDDebugViewControllerItem *item = [_tableContents objectAtIndex:indexPath.row];
	[self performSelectorOnMainThread:item.selector withObject:nil waitUntilDone:YES];
}

- (APDDebugViewControllerItem *)tableItemWithName:(NSString *)name andSelector:(SEL)selector{
	APDDebugViewControllerItem *item = [[APDDebugViewControllerItem alloc] init];
	item.name = name;
	item.selector = selector;
	return item;
}


- (void)theFiveCs{
	
}

- (void)tipsAndTricks{
	
}

- (void)sendFeedback{
	
}

- (void)restorePurchases{
	
}

- (void)removeAds{
	
}

- (void)termsAndPrivacy{
	
}

- (void)appSettings{
	
}

- (void)logout{
	
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
