#import "SNFModel.h"

static SNFModel *_instance;

@implementation SNFModel

+ (SNFModel *)sharedInstance{
	if(!_instance){
		_instance = [[SNFModel alloc] init];
	}
	return _instance;
}

- (id)init{
	self = [super init];
	_config = [[SNFConfig alloc] init];
	return self;
}

@end
