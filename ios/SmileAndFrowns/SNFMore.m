
#import "SNFMore.h"
#import "AppDelegate.h"
#import "SNFLauncher.h"
#import "SNFUserService.h"
#import "SNFModel.h"
#import "SNFTutorial.h"
#import "SNFAcceptInvite.h"
#import "ATIFacebookAuthHandler.h"
#import "UIAlertAction+Additions.h"
#import "SNFADBannerView.h"

@interface SNFMore ()
@property IAPHelper * helper;
@end

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
					   [self tableItemWithName:@"View the Tutorial" andSelector:@selector(tutorial)],
					   [self tableItemWithName:@"Launcher" andSelector:@selector(launcher)],
					   [self tableItemWithName:@"Accept An Invite Code" andSelector:@selector(acceptInviteFromCode)],
					   [self tableItemWithName:@"Logout" andSelector:@selector(logout)],
					   ];
	[self.tableView reloadData];
}

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return TRUE;
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

- (void) tutorial {
	SNFTutorial * tutorial = [[SNFTutorial alloc] init];
	tutorial.userInitiatedTutorial = TRUE;
	[AppDelegate instance].window.rootViewController = tutorial;
}

- (void) acceptInviteFromCode {
	SNFAcceptInvite * accept = [[SNFAcceptInvite alloc] init];
	[[AppDelegate rootViewController] presentViewController:accept animated:TRUE completion:nil];
}

- (void)theFiveCs{
	
}

- (void)tipsAndTricks{
	
}

- (void)sendFeedback{
	
}

- (void) restorePurchases {
	
	if(!self.helper) {
		self.helper = [[IAPHelper alloc] init];
	}
	
	__weak SNFMore * weakself = self;
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[self.helper restorePurchasesWithCompletion:^(NSError *error, SKPaymentTransaction *transaction, BOOL completed) {
		
		NSString * productId = transaction.payment.productIdentifier;
		NSString * type = [IAPHelper productTypeForProductId:productId];
		
		if([[IAPHelper productNameByProductId:productId] isEqualToString:@"RemoveAds"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFADBannerViewPurchasedRemoveAds object:nil];
		}
		
		NSLog(@"restore product id: %@, transaction id: %@",productId,transaction.transactionIdentifier);
		
		if([type isEqualToString:@"Consumable"]) {
			//TODO: handle looking up board based on product identifier and show an error if it doesn't exist?
		}
		
		if(completed) {
			[MBProgressHUD hideHUDForView:weakself.view animated:TRUE];
			
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your purchases were restored" preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
		}
		
	}];
	
}

- (void) removeAds {
	
	IAPHelper * helper = [[IAPHelper alloc] init];
	
	NSArray * products = [IAPHelper productIdsByNames:@[@"RemoveAds"]];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[helper loadItunesProducts:products withCompletion:^(NSError *error) {
		
		NSString * product = [IAPHelper productIdByName:@"RemoveAds"];
		
		[helper purchaseItunesProductId:product completion:^(NSError *error, SKPaymentTransaction *transaction) {
			
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			if(error) {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Error" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction OKAction]];
				[self presentViewController:alert animated:TRUE completion:nil];
			} else {
				[[NSNotificationCenter defaultCenter] postNotificationName:SNFADBannerViewPurchasedRemoveAds object:nil];
			}
			
		}];
		
	}];
	
}

- (void)termsAndPrivacy{
	
}

- (void)appSettings{
	
}

- (void) logout {
	[[ATIFacebookAuthHandler instance] logout];
	
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
