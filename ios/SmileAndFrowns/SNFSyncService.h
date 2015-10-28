#import <Foundation/Foundation.h>
#import "SNFService.h"

typedef void(^SNFSyncServiceCallback)(NSError *error, NSObject *boardData);

@interface SNFSyncService : SNFService

- (void)syncWithCompletion:(SNFSyncServiceCallback)completion;

@end
