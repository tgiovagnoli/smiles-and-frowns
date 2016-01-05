
#import "AppDelegate.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "SNFModel.h"
#import "SNFDateManager.h"
#import "SNFViewController.h"
#import "SNFTutorial.h"
#import "SNFLauncher.h"
#import "SNFAcceptInvite.h"
#import "SNFLogin.h"
#import "SNFCreateAccount.h"
#import "NSTimer+Blocks.h"
#import "SNFSyncService.h"
#import <HockeySDK/HockeySDK.h>
#import "UIImageLoader.h"
#import "GATracking.h"

static AppDelegate * _instance;

@interface AppDelegate ()
@end

@implementation AppDelegate

+ (AppDelegate *) instance {
	return _instance;
}

+ (UIViewController *) rootViewController; {
	return _instance.window.rootViewController;
}

- (BOOL) application:(UIApplication *) application didFinishLaunchingWithOptions:(NSDictionary *) launchOptions {
	_instance = self;
	
	[[GATracking instance] initTagManagerWithID:@"GTM-T7XD6P"];
	[[GATracking instance] setLogLevel:kTAGLoggerLogLevelNone];
	
	UIUserNotificationType userNotificationTypes = UIUserNotificationTypeBadge;
	UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
	[application registerUserNotificationSettings:settings];
	
	UIImageLoader * loader = [UIImageLoader defaultLoader];
	NSLog(@"disk cache: %@",loader.cacheDirectory);
	loader.useServerCachePolicy = FALSE;
	loader.trustAnySSLCertificate = TRUE;
	loader.cacheImagesInMemory = TRUE;
	loader.memoryCache.maxBytes = 52428800; //50MB
	[loader clearCachedFilesModifiedOlderThan1Week];
	[loader setAuthUsername:[SNFModel sharedInstance].config.profileImageAuthUsername password:[SNFModel sharedInstance].config.profileImageAuthPassword];
	
	[SNFModel sharedInstance].managedObjectContext = self.managedObjectContext;
	[SNFDateManager unlock];
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	[[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"530994a421524ee9916ed2cc1a103f1f"];
	[[BITHockeyManager sharedHockeyManager] startManager];
	[[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
	
	[FBSDKAppEvents activateApp];
	[[FBSDKApplicationDelegate sharedInstance] application:application didFinishLaunchingWithOptions:launchOptions];
	
	if(![SNFTutorial hasSeenTutorial]) {
		self.window.rootViewController = [[SNFTutorial alloc] init];
	} else if([SNFLauncher showAtLaunch] || ![SNFModel sharedInstance].loggedInUser) {
		self.window.rootViewController = [[SNFLauncher alloc] init];
	} else {
		self.window.rootViewController = [[SNFViewController alloc] init];
	}
	
	[self.window makeKeyAndVisible];
	
	return YES;
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
	
	if([url.scheme hasPrefix:@"fb"]) {
		return [FBAppCall handleOpenURL:url sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]];
	}
	
	if([url.scheme isEqualToString:@"snf"]) {
		
		//get absolute path - like snf://invite/09sdf84
		//look for handled url routes below
		NSString * path = [url absoluteString];
		
		//look for invite code.
		NSArray * parts = [path componentsSeparatedByString:@"snf://invite/"];
		if(parts.count == 2) {
			
			//set pending invite code.
			NSString * inviteCode = [parts objectAtIndex:1];
			[SNFModel sharedInstance].pendingInviteCode = inviteCode;
			
			if(![SNFModel sharedInstance].loggedInUser) {
				//not logged in
				
				if([[AppDelegate rootViewController] isKindOfClass:[SNFLauncher class]]) {
					
					SNFLauncher * launcher = (SNFLauncher *)[AppDelegate rootViewController];
					SNFCreateAccount * signup = [[SNFCreateAccount alloc] initWithSourceView:launcher.createAccountButton sourceRect:CGRectZero contentSize:CGSizeMake(500,480)];
					signup.nextViewController = [[SNFAcceptInvite alloc] initWithSourceView:launcher.acceptInviteButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
					[[AppDelegate rootViewController] presentViewController:signup animated:TRUE completion:nil];
					
				}
				
			} else {
				//logged in
				
				//not currently on main view controller. go to invites and show accept modal.
				if(![SNFViewController instance]) {
					
					SNFViewController * root = [[SNFViewController alloc] init];
					root.firstTab = SNFTabInvites;
					self.window.rootViewController = root;
					
					[NSTimer scheduledTimerWithTimeInterval:.25 block:^{
						SNFAcceptInvite * acceptInvite = [[SNFAcceptInvite alloc] initWithSourceView:root.tabMenu.invitesButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
						acceptInvite.inviteCode = inviteCode;
						[[AppDelegate rootViewController] presentViewController:acceptInvite animated:TRUE completion:nil];
					} repeats:FALSE];
					
				} else if([SNFViewController instance]) {
					
					//already at main view controller, go to invites and show accept modal.
					
					SNFViewController * root = [SNFViewController instance];
					[root showInvitesAnimated:TRUE];
					
					[NSTimer scheduledTimerWithTimeInterval:.25 block:^{
						SNFAcceptInvite * acceptInvite = [[SNFAcceptInvite alloc] initWithSourceView:root.tabMenu.invitesButton sourceRect:CGRectZero contentSize:CGSizeMake(360,190)];
						acceptInvite.inviteCode = inviteCode;
						[[AppDelegate rootViewController] presentViewController:acceptInvite animated:TRUE completion:nil];
					} repeats:FALSE];
					
				}
			}
		}
		
		return TRUE;
	}
	
	return FALSE;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
	[[SNFSyncService instance] saveContext];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	if(![SNFSyncService instance].syncing) {
		[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {}];
	}
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[[SNFSyncService instance] saveContext];
}

- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
	if([SNFModel sharedInstance].loggedInUser){
		SNFUserService *userService = [[SNFUserService alloc] init];
		[userService invitesWithCompletion:^(NSError *error, NSArray * received_invites, NSArray * sent_invites) {
			if(error){
				completionHandler(UIBackgroundFetchResultFailed);
			}else{
				[[UIApplication sharedApplication] setApplicationIconBadgeNumber:received_invites.count];
				// now sync
				[[SNFSyncService instance] syncWithCompletion:^(NSError *error, NSObject *boardData) {
					if(error){
						completionHandler(UIBackgroundFetchResultFailed);
					}else{
						for(NSDictionary *item in (NSArray *)boardData){
							if([item objectForKey:@"has_updates"]){
								NSNumber *hasUpdates = [item objectForKey:@"has_updates"];
								if([hasUpdates boolValue]){
									completionHandler(UIBackgroundFetchResultNewData);
								}else{
									completionHandler(UIBackgroundFetchResultNoData);
								}
							}
						}
						completionHandler(UIBackgroundFetchResultNewData);
					}
				}];
			}
		}];
	}
}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.apptitude.SmileAndFrowns" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *) applicationSupportDirectory; {
	NSURL * appSupport = [[[NSFileManager defaultManager] URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask] lastObject];
	[[NSFileManager defaultManager] createDirectoryAtURL:appSupport withIntermediateDirectories:TRUE attributes:nil error:nil];
	return appSupport;
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SmileAndFrowns" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationSupportDirectory] URLByAppendingPathComponent:@"SmileAndFrowns.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return _persistentStoreCoordinator;
}

- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
