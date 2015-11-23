
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
#import "ATITwitterAuthHandler.h"
#import "SNFViewController.h"
#import "SNFSyncService.h"

#define SHARE_APP_NAME @"Share this App"

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
					   [self tableItemWithName:@"Accept An Invite Code" andSelector:@selector(acceptInviteFromCode:)],
					   [self tableItemWithName:@"Reset Local Data" andSelector:@selector(resetLocalSync)],
					   [self tableItemWithName:SHARE_APP_NAME andSelector:@selector(shareApp)],
					   [self tableItemWithName:@"Logout" andSelector:@selector(logout)],
					   ];
	[self.tableView reloadData];
}

- (void) testBadge {
	[UIApplication sharedApplication].applicationIconBadgeNumber = 10;
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
	UITableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
	[self performSelectorOnMainThread:item.selector withObject:cell waitUntilDone:YES];
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

- (void) acceptInviteFromCode:(UITableViewCell *) cell {
	SNFAcceptInvite * accept = [[SNFAcceptInvite alloc] initWithSourceView:cell sourceRect:CGRectZero contentSize:CGSizeMake(360,190) arrowDirections:UIPopoverArrowDirectionUp|UIPopoverArrowDirectionDown];
	[[AppDelegate rootViewController] presentViewController:accept animated:TRUE completion:nil];
}

- (void)theFiveCs{
	[self showWebDetailWithURLString:@"http://smilesandfrowns.com/five_cs/" andTitle:@"The Five C's"];
}

- (void)tipsAndTricks{
	[self showWebDetailWithURLString:@"http://smilesandfrowns.com/tips_and_tricks/" andTitle:@"Tips and Tricks"];
}

- (void)sendFeedback{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://smilesandfrowns.com/feedback/"]];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
	[[AppDelegate rootViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (void)termsAndPrivacy{
	[self showWebDetailWithURLString:@"http://smilesandfrowns.com/terms_and_privacy/" andTitle:@"Terms & Privacy"];
}

- (void)appSettings{
	
}

- (void)showWebDetailWithURLString:(NSString *)urlString andTitle:(NSString *)title{
	NSURL *url = [NSURL URLWithString:urlString];
	SNFMoreWebDetail *webDetail = [[SNFMoreWebDetail alloc] init];
	[[SNFViewController instance].viewControllerStack pushViewController:webDetail animated:YES];
	[NSTimer scheduledTimerWithTimeInterval:0.5 block:^{
		[webDetail setTitle:title andURL:url];
	} repeats:NO];
}

- (void) restorePurchases {
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[[IAPHelper defaultHelper] restorePurchasesWithCompletion:^(NSError *error, SKPaymentTransaction *transaction, BOOL completed) {
		
		NSString * productId = transaction.payment.productIdentifier;
		NSString * type = [[IAPHelper defaultHelper] productTypeForProductId:productId];
		
		if([[[IAPHelper defaultHelper] productNameByProductId:productId] isEqualToString:@"RemoveAds"]) {
			[[NSNotificationCenter defaultCenter] postNotificationName:SNFADBannerViewPurchasedRemoveAds object:nil];
		}
		
		NSLog(@"restore product id: %@, transaction id: %@",productId,transaction.transactionIdentifier);
		
		if([type isEqualToString:@"Consumable"]) {
			//TODO: handle looking up board based on product identifier and show an error if it doesn't exist?
		}
		
		if(completed) {
			[MBProgressHUD hideHUDForView:self.view animated:TRUE];
			
			UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Success" message:@"Your purchases were restored" preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction OKAction]];
			[self presentViewController:alert animated:TRUE completion:nil];
		}
		
	}];
	
}

- (void) removeAds {
	
	NSArray * products = [[IAPHelper defaultHelper] productIdsByNames:@[@"RemoveAds"]];
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	
	[[IAPHelper defaultHelper] loadItunesProducts:products withCompletion:^(NSError *error) {
		
		NSString * product = [[IAPHelper defaultHelper] productIdByName:@"RemoveAds"];
		
		[[IAPHelper defaultHelper] purchaseItunesProductId:product completion:^(NSError *error, SKPaymentTransaction *transaction) {
			
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

- (void)resetLocalSync{
	UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Warning" message:@"This will delete all of your local data and use only what is found on the server.  It should only be used if you are having issues with synchronizing boards.  Are you sure you want to do this?" preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction actionWithTitle:@"Delete" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
		if([SNFSyncService instance].syncing){
			[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
			[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onSyncComplete:) name:SNFSyncServiceCompleted object:nil];
			return;
		}
		[self purgeAndSync];
	}]];
	[alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
	[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
}

- (void)purgeAndSync{
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	[SNFModel sharedInstance].userSettings.lastSyncDate = nil;
	[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
		[MBProgressHUD hideHUDForView:self.view animated:NO];
		if(error){
			if(error.code == SNFErrorCodeDjangoDebugError){
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:@"Something went wrong.  Please contact the smiles and frowns team for further assistance." preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
			}else{
				UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
				[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
			}
		}else{
			UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"" message:@"Your boards have been reset to the last state set on the server." preferredStyle:UIAlertControllerStyleAlert];
			[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
			[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
		}
	}];
}

- (void)onSyncComplete:(NSNotification *)notification{
	[MBProgressHUD hideHUDForView:self.view animated:NO];
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self purgeAndSync];
}

- (void)shareApp{
	NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com/app/id1058499314"];
	NSArray *items = @[url];
	UIActivityViewController *avc = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
		avc.modalPresentationStyle = UIModalPresentationPopover;
		UIPopoverPresentationController *popoverController = [avc popoverPresentationController];
		popoverController.permittedArrowDirections = UIPopoverArrowDirectionAny;
		popoverController.sourceView = self.tableView;
		NSInteger row = 0;
		for(APDDebugViewControllerItem *item in _tableContents){
			if([item.name isEqualToString:SHARE_APP_NAME]){
				break;
			}
			row++;
		}
		UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
		if(cell){
			popoverController.sourceRect = cell.frame;
		}
	}
	[[SNFViewController instance] presentViewController:avc animated:YES completion:^{}];
}

@end
