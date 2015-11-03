
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SNFConfig.h"
#import "SNFUser.h"
#import "SNFUserSettings.h"

@interface SNFModel : NSObject {
	SNFUser * _loggedInUser;
}

@property NSManagedObjectContext * managedObjectContext;
@property (readonly) SNFConfig * config;
@property (readonly) SNFUserSettings * userSettings;
@property (nonatomic) SNFUser * loggedInUser;
@property NSString * pendingInviteCode;

+ (SNFModel *)sharedInstance;

- (NSString *) lastLoggedInUsername;
- (void)setLoggedInUser:(SNFUser *)loggedInUser updateLastLoggedIn:(BOOL)updateLastLoggedIn;

@end
