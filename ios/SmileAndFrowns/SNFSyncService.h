#import <Foundation/Foundation.h>
#import "SNFService.h"

typedef void(^SNFSyncServiceCallback)(NSError *error, NSArray *boardData);

@interface SNFSyncService : SNFService

- (void)syncFromRemoteWithBoards:(NSArray *)boards andCompletion:(SNFSyncServiceCallback)completion;

@end
