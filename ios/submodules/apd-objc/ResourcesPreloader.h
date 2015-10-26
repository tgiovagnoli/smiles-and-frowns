
#import <UIKit/UIKit.h>
#import "FTPSyncChilkat.h"

@class ResourcesPreloader;

@protocol ZipProgressDelegate <NSObject>
- (void) PercentDone:(NSNumber *)pctDone;
@end

@protocol ResourcesPreloaderDelegate <NSObject>
@optional
- (void) resourcesPreloader:(ResourcesPreloader *) preloader progress:(float) progress;
- (void) resourcesPreloaderCompleted:(ResourcesPreloader *) preloader;
- (void) resourcesPreloader:(ResourcesPreloader *) preloader zipDownloadFailedWithError:(NSError *) error;
- (void) resourcesPreloaderUnzipFailed:(ResourcesPreloader *) preloader;
@end

//This class downloads a zip file and unzips it.
//The progress is calculated for both download and the unzip progress.
@interface ResourcesPreloader : NSObject <NSCoding,FTPSyncChilkatDelegate,ZipProgressDelegate,NSURLConnectionDelegate,NSURLConnectionDataDelegate>

@property NSObject <ResourcesPreloaderDelegate> * delegate;
@property NSString * chilkatKey;
@property NSURL * remoteZipURL;
@property NSURL * localZipURL;

@property BOOL alwaysReload;

//check if a preloader can be restored
+ (BOOL) canRestorePreloaderForLocalZipFile:(NSURL *) url;

//this restores a ResourcesPreloader from disk.
+ (ResourcesPreloader *) resourcePreloaderForLocalZipURL:(NSURL *)url;

//starts the download or resumes an existing download.
- (void) resume;

//stops the download but doesn't zip file
- (void) stop;

//stop download and deletes zip file.
- (void) cancel;

//deletes the zip file. The zip is automatically deleted after download/unzip is completed.
- (void) deleteZipFile;

@end
