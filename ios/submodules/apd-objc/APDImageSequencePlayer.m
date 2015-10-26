#import "APDImageSequencePlayer.h"

@implementation APDImageSequencePlayer

- (id)initWithDirectory:(NSURL *)directory fileName:(NSString *)fileName andFPS:(CGFloat)fps{
	self = [super init];
	self.fileDirectory = directory;
	self.fileName = fileName;
	self.fps = fps;
	[self refresh];
	return self;
}

- (id)init{
	self = [super init];
	[self defaults];
	return self;
}

- (id)initWithFrame:(CGRect)frame{
	self = [super initWithFrame:frame];
	[self defaults];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	[self defaults];
	return self;
}

- (id)initWithImage:(UIImage *)image{
	self = [super initWithImage:image];
	[self defaults];
	return self;
}

- (void)defaults{
	self.stopAtFrame = -1;
	self.fileDirectory = [[NSBundle mainBundle] bundleURL];
	self.fps = 24.0;
}

- (void)refresh{
	[self populateImagePaths];
	self.position = 0.0;
}

- (void)populateImagePaths{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSError *error;
	NSArray *contents = [fm contentsOfDirectoryAtPath:self.fileDirectory.path error:&error];
	NSArray *tests = [self.fileName componentsSeparatedByString:@"*"];
	NSAssert(tests.count == 2, @"String for filename must be formatted as file*.png with no extra wildcard characters.");
	NSString *prefix = [tests objectAtIndex:0];
	NSString *suffix = [tests objectAtIndex:1];
	NSMutableArray *files = [[NSMutableArray alloc] init];
	for(NSString *file in contents){
		if([file hasPrefix:prefix] && [file hasSuffix:suffix]){
			[files addObject:file];
		}
	}
	NSArray *sortedFiles = [files sortedArrayUsingComparator:^NSComparisonResult(NSString *file1, NSString *file2) {
		return [file1 compare:file2];
	}];
	files = [[NSMutableArray alloc] init];
	NSString *fullPath;
	for(NSString *fileName in sortedFiles){
		fullPath = [self.fileDirectory.path stringByAppendingPathComponent:fileName];
		[files addObject:[NSURL fileURLWithPath:fullPath]];
	}
	_fileURLs  = [NSArray arrayWithArray:files];
}

- (CGFloat)duration{
	return (CGFloat)_fileURLs.count/self.fps;
}

- (NSUInteger) currentFrame {
	return floor(_position * self.fps);
}

- (void)setPosition:(CGFloat)position{
	if(_fileURLs.count == 0){
		return;
	}else if(position < 0){
		position = 0;
	}else if(position >= _fileURLs.count){
		position = _fileURLs.count - 1;
	}
	_position = position;
	
	NSUInteger currentFrame = [self currentFrame];
	if(currentFrame >= _fileURLs.count){
		currentFrame = _fileURLs.count - 1;
	}
	NSURL *imageURL = [self.fileURLs objectAtIndex:currentFrame];
	UIImage *image = [UIImage imageWithContentsOfFile:imageURL.path];
	self.image = image;
}

- (void) playToFrame:(CGFloat) frame {
	self.stopAtFrame = frame;
	[self play];
}

- (void)seekToFrame:(CGFloat)frame{
	self.position = frame/self.fps;
}

- (void)play{
	if(_playTimer){
		[_playTimer invalidate];
	}
	_playTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/self.fps target:self selector:@selector(onTimerTick:) userInfo:nil repeats:YES];
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(sequencePlayerPlayed:)]) {
		[self.delegate sequencePlayerPlayed:self];
	}
}

- (void)pause{
	if(_playTimer){
		[_playTimer invalidate];
		_playTimer = nil;
	}
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(sequencePlayerPaused:)]) {
		[self.delegate sequencePlayerPaused:self];
	}
}

- (void)stop{
	if(_playTimer){
		[_playTimer invalidate];
		_playTimer = nil;
	}
	self.position = 0.0;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(sequencePlayerStopped:)]) {
		[self.delegate sequencePlayerStopped:self];
	}
}

- (void)onTimerTick:(NSTimer *)timer{
	CGFloat posOffset = 1.0/self.fps;
	CGFloat next = self.position + posOffset;
	
	if(self.stopAtFrame > -1 && self.stopAtFrame < [self currentFrame]) {
		next = self.position - posOffset;
	}
	
	if(next > self.duration) {
		if(self.repeats){
			self.position = 0.0;
			return;
		}else{
			self.position = self.duration;
			[self pause];
		}
	}
	
	self.position = next;
	
	if(self.delegate && [self.delegate respondsToSelector:@selector(sequencePlayerEnterFrame:)]) {
		[self.delegate sequencePlayerEnterFrame:self];
	}
	
	if([self currentFrame] == self.stopAtFrame) {
		[self pause];
		self.stopAtFrame = -1;
	}
}

@end
