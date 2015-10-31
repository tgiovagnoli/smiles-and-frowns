
#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFDateManager.h"

typedef void(^SNFSyncServiceCallback)(NSError *error, NSObject *boardData);

@interface SNFSyncService : SNFService

+ (SNFSyncService *) instance;
- (void)syncWithCompletion:(SNFSyncServiceCallback)completion;
- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion;

@end
