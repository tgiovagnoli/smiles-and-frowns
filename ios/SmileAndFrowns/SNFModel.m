
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

- (void) setLoggedInUser:(SNFUser *) loggedInUser {
	_loggedInUser = loggedInUser;
	if(!loggedInUser) {
		[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SNFModel.LoggedInUser"];
	} else {
		[[NSUserDefaults standardUserDefaults] setObject:loggedInUser.username forKey:@"SNFModel.LoggedInUser"];
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
	return [[NSUserDefaults standardUserDefaults] objectForKey:@"SNFModel.LoggedInUser"];
}

@end
