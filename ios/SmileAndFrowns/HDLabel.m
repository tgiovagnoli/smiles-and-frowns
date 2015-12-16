
#import "HDLabel.h"

@implementation HDLabel

+ (Class) layerClass {
	return [CATiledLayer class];
}

- (id) initWithFrame:(CGRect) r {
	self = [super initWithFrame:r];
	CATiledLayer * tempTiledLayer = (CATiledLayer*)self.layer;
	tempTiledLayer.levelsOfDetail = 5;
	tempTiledLayer.levelsOfDetailBias = 3;
	return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	CATiledLayer * tempTiledLayer = (CATiledLayer*)self.layer;
	tempTiledLayer.levelsOfDetail = 5;
	tempTiledLayer.levelsOfDetailBias = 3;
	return self;
}

@end
