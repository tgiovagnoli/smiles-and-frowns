
#import <UIKit/UIKit.h>

@class APDImageSequencePlayer;

@protocol APDImageSequencePlayerDelegate <NSObject>
- (void) sequencePlayerPaused:(APDImageSequencePlayer *) player;
- (void) sequencePlayerStopped:(APDImageSequencePlayer *) player;
- (void) sequencePlayerPlayed:(APDImageSequencePlayer *) player;
- (void) sequencePlayerEnterFrame:(APDImageSequencePlayer *) player;
@end

@interface APDImageSequencePlayer : UIImageView {
	NSTimer *_playTimer;
}

@property NSURL *fileDirectory;
@property NSString *fileName;
@property CGFloat fps;
@property (readonly) NSArray *fileURLs;
@property (nonatomic) CGFloat position;
@property BOOL repeats;
@property float stopAtFrame;
@property NSObject <APDImageSequencePlayerDelegate> * delegate;

- (id)initWithDirectory:(NSURL *)directory fileName:(NSString *)fileName andFPS:(CGFloat)fps;
- (CGFloat)duration;
- (NSUInteger)currentFrame;
- (void)play;
- (void)playToFrame:(CGFloat) frame;
- (void)seekToFrame:(CGFloat)frame;
- (void)pause;
- (void)stop;
- (void)refresh;

@end
