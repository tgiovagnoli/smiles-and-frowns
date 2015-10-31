
#import "AppDelegate.h"
#import "SNFModel.h"
#import "SNFDateManager.h"
#import "SNFViewController.h"
#import "SNFTutorial.h"
#import "SNFLauncher.h"
#import "SNFAcceptInvite.h"
#import "SNFLogin.h"

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
	
	self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
	
	if(![SNFTutorial hasSeenTutorial]) {
		self.window.rootViewController = [[SNFTutorial alloc] init];
	} else if([SNFLauncher showAtLaunch]) {
		self.window.rootViewController = [[SNFLauncher alloc] init];
	} else {
		self.window.rootViewController = [[SNFViewController alloc] init];
	}
	
	[self.window makeKeyAndVisible];
	
	[SNFModel sharedInstance].managedObjectContext = self.managedObjectContext;
	[SNFDateManager unlock];
	
	application.statusBarHidden = YES;
	
	return YES;
}

- (BOOL) application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString *,id> *)options {
	if([url.scheme isEqualToString:@"snf"]) {
		
		//get absolute path - like snf://invite/09sdf84
		//look for handled url routes below
		NSString * path = [url absoluteString];
		
		//look for generic go to invites
		if([path isEqualToString:@"snf://invites"]) {
			
			if([[AppDelegate rootViewController] isKindOfClass:[SNFViewController class]]) {
				[[SNFViewController instance] showInvitesAnimated:FALSE];
			} else {
				UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Login Required" message:@"Login to see your board invitations" preferredStyle:UIAlertControllerStyleAlert];
				[alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
				[[AppDelegate rootViewController] presentViewController:alert animated:TRUE completion:nil];
			};
			
			return TRUE;
		}
		
		//look for invite code.
		NSArray * parts = [path componentsSeparatedByString:@"snf://invite/"];
		if(parts.count == 2) {
			
			//set pending invite code.
			NSString * inviteCode = [parts objectAtIndex:1];
			[SNFModel sharedInstance].pendingInviteCode = inviteCode;
			
			if(![SNFModel sharedInstance].loggedInUser) {
				
				//show login view,
				SNFLogin * login = [[SNFLogin alloc] init];
				SNFAcceptInvite * acceptInvite = [[SNFAcceptInvite alloc] init];
				login.nextViewController = acceptInvite;
				[[AppDelegate rootViewController] presentViewController:login animated:TRUE completion:nil];
				
			} else {
				
				if(self.window.rootViewController.presentingViewController) {
					
					[[AppDelegate rootViewController] dismissViewControllerAnimated:TRUE completion:^{
						
						//user is logged in here, show the invites view.
						if(![SNFViewController instance]) {
							SNFViewController * root = [[SNFViewController alloc] init];
							root.firstTab = SNFTabInvites;
							self.window.rootViewController = root;
						}
						
					}];
					
				} else {
					
					//user is logged in here, show the invites view.
					if([self.window.rootViewController isKindOfClass:[SNFLauncher class]]) {
						SNFViewController * root = [[SNFViewController alloc] init];
						root.firstTab = SNFTabInvites;
						self.window.rootViewController = root;
					}
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
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
	// Saves changes in the application's managed object context before the application terminates.
	[self saveContext];
}

- (void) finishTutorial:(BOOL) userInitiatedTutorial {
	if(!userInitiatedTutorial && [SNFLauncher showAtLaunch]) {
		self.window.rootViewController = [[SNFLauncher alloc] init];
	} else {
		self.window.rootViewController = [[SNFViewController alloc] init];
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
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SmileAndFrowns.sqlite"];
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
