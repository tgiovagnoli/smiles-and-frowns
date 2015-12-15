
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import <FacebookSDK/FacebookSDK.h>
#import "GATracking.h"
#import "NSURLRequest+Additions.h"
#import "UIColor+Hex.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

+ (AppDelegate *) instance;
+ (UIViewController *) rootViewController;
- (void) saveContext;
- (NSURL *) applicationDocumentsDirectory;
- (NSURL *) applicationSupportDirectory;

@end

