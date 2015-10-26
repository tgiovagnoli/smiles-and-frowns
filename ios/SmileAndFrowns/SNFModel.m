#import "SNFModel.h"

static SNFModel *_instance;

@implementation SNFModel

+ (SNFModel *)sharedInstance{
	if(!_instance){
		_instance = [[SNFModel alloc] init];
	}
	return _instance;
}

@end
