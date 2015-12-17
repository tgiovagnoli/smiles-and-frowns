
#import <Foundation/Foundation.h>
#import "SNFService.h"
#import "SNFDateManager.h"

extern NSString * const SNFSyncServiceCompleted;
extern NSString * const SNFSyncServiceError;

typedef void(^SNFSyncServiceCallback)(NSError *error, NSObject *boardData);

@interface SNFSyncService : SNFService <NSURLSessionDelegate> {
	NSTimer *_syncTimer;
}

@property (readonly) BOOL syncing;

+ (SNFSyncService *) instance;
- (void)syncWithCompletion:(SNFSyncServiceCallback)completion;
- (void)updateLocalDataWithResults:(NSDictionary *)results andCallCompletion:(SNFSyncServiceCallback)completion;
- (void)syncPredefinedBoardsWithCompletion:(SNFSyncServiceCallback)completion;
- (void)saveContext;

@end
