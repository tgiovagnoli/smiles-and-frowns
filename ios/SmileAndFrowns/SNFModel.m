
#import "SNFModel.h"
#import "SNFUser.h"

static SNFModel *_instance;

@implementation SNFModel

+ (SNFModel *) sharedInstance {
	if(!_instance) {
		_instance = [[SNFModel alloc] init];
	}
	return _instance;
}

- (id) init {
	self = [super init];
	_config = [[SNFConfig alloc] init];
	_userSettings = [[SNFUserSettings alloc] init];
	return self;
}

static int _showInterstitial = 0;

- (void) resetInterstitial {
	_showInterstitial = 0;
}

- (BOOL) shouldShowInterstitial; {
	_showInterstitial++;
	if(_showInterstitial >= 20) {
		return TRUE;
	}
	return FALSE;
}

- (void) setLoggedInUser:(SNFUser *) loggedInUser {
	_loggedInUser = loggedInUser;
	if(loggedInUser) {
		[[NSUserDefaults standardUserDefaults] setObject:loggedInUser.username forKey:@"SNFModel.LastLoggedInUser"];
		[[NSUserDefaults standardUserDefaults] setObject:loggedInUser.username forKey:@"SNFModel.LoggedInUser"];
	} else {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SNFModel.LoggedInUser"];
	}
}

- (void)setLoggedInUser:(SNFUser *)loggedInUser updateLastLoggedIn:(BOOL)updateLastLoggedIn{
	_loggedInUser = loggedInUser;
	if(loggedInUser && updateLastLoggedIn){
		[[NSUserDefaults standardUserDefaults] setObject:loggedInUser.username forKey:@"SNFModel.LastLoggedInUser"];
		[[NSUserDefaults standardUserDefaults] setObject:loggedInUser.username forKey:@"SNFModel.LoggedInUser"];
	}else if(updateLastLoggedIn){
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SNFModel.LoggedInUser"];
	}
}

- (SNFUser *) loggedInUser {
	if(!_loggedInUser) {
		NSString * username = [[NSUserDefaults standardUserDefaults] objectForKey:@"SNFModel.LoggedInUser"];
		if(username) {
			NSError * error = nil;
			NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
			NSEntityDescription * entity = [NSEntityDescription entityForName:@"SNFUser" inManagedObjectContext:[SNFModel sharedInstance].managedObjectContext];
			[fetchRequest setEntity:entity];
			[fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"(username = %@)",username]];
			NSArray * fetchedObjects = [[SNFModel sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
			if(error) {
				NSLog(@"error making query: %@",error);
				return nil;
			}
			if(fetchedObjects.count > 0) {
				_loggedInUser = [fetchedObjects objectAtIndex:0];
			}
		}
	}
	return _loggedInUser;
}

- (NSString *) lastLoggedInUsername; {
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"SNFModel.LastLoggedInUser"];
}

@end
