#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFDateManager.h"

typedef void(^SNFSyncServiceCallback)(NSError *error, NSObject *boardData);

@interface SNFSyncService : SNFService

- (void)syncWithCompletion:(SNFSyncServiceCallback)completion;

@end
