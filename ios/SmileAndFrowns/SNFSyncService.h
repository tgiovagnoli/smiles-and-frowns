
#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFDateManager.h"

extern NSString * const SNFSyncServiceCompleted;

typedef void(^SNFSyncServiceCallback)(NSError *error, NSObject *boardData);

@interface SNFSyncService : SNFService{
	NSTimer *_syncTimer;
}

@property (readonly) BOOL syncing;

+ (SNFSyncService *) instance;
- (void)syncWithCompletion:(SNFSyncServiceCallback)completion;
- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion;
- (void)syncPredefinedBoardsWithCompletion:(SNFSyncServiceCallback)completion;
- (void)flagContextForSave;

@end
