
#import "SNFMore.h"
#import "AppDelegate.h"
#import "SNFLauncher.h"
#import "SNFUserService.h"
#import "SNFModel.h"

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
					   [self tableItemWithName:@"Launcher" andSelector:@selector(launcher)],
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

- (void) launcher {
	[AppDelegate instance].window.rootViewController = [[SNFLauncher alloc] init];
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

- (void) logout {
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	SNFUserService * service = [[SNFUserService alloc] init];
	
	[service logoutWithCompletion:^(NSError *error) {
		
		[MBProgressHUD hideHUDForView:self.view animated:TRUE];
		
		if(error) {
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
			[self presentViewController:alert animated:TRUE completion:nil];
			return;
		}
		
		[SNFModel sharedInstance].loggedInUser = nil;
		
		[AppDelegate instance].window.rootViewController = [[SNFLauncher alloc] init];
		
	}];
}

@end
