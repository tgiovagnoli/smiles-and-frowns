
#import <Foundation/Foundation.h>

//notifications
extern NSString * const FTPSyncChilkatStarted;
extern NSString * const FTPSyncChilkatCompleted;
extern NSString * const FTPSyncChilkatFailed;

@class FTPSyncChilkat;

//delegate
@protocol FTPSyncChilkatDelegate <NSObject>
@optional
- (void) ftpSyncChilkatDidStart:(FTPSyncChilkat *) ftpSync;
- (void) ftpSyncChilkatDidFail:(FTPSyncChilkat *) ftpSync;
- (void) ftpSyncChilkatDidComplete:(FTPSyncChilkat *) ftpSync;
@end

@interface FTPSyncChilkat : NSObject <NSCoding>

//use the delegate if you don't want to use notifications.
@property NSObject <FTPSyncChilkatDelegate> * delegate;

//the files synced. available after it completes syncing.
@property NSArray * syncedFiles;

//if false after a sync completes the localDir will be set as do not backup.
//defaults to true.
@property BOOL allowItunesBackup;

//init with required properties.
- (id) initWithChilkatFTPKey:(NSString *) key host:(NSString *) host port:(NSUInteger) port secure:(BOOL) secure username:(NSString *) username password:(NSString *) password;

//sync remote dir to local dir.
- (void) syncRemoteDirectory:(NSURL *) remoteDir toLocalDir:(NSURL *) localDir;

//sync remote dir to local dir with a specific mode.
//mode option docs (default is 5) https://www.chilkatsoft.com/refdoc/objcCkoFtp2Ref.html
- (void) syncRemoteDirectory:(NSURL *) remoteDir toLocalDir:(NSURL *) localDir withSyncMode:(NSUInteger) mode;

//optionally you can set these one at a time before syncing.
- (void) setLocalFTPDir:(NSURL *) url;
- (void) setRemoteFTPDir:(NSURL *) url;
- (void) syncFTP;

//creates a debug file for Chilkat library. Look in console logs for file path.
- (void) debugLog:(BOOL) debug;

@end
