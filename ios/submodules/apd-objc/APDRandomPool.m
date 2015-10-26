#import "APDRandomPool.h"

@implementation APDRandomPool

- (id)initWithArray:(NSArray *)array{
	self = [super init];
	self.array = array;
	return self;
}

- (void)setArray:(NSArray *)array{
	_array = array;
	_pool = [[NSMutableArray alloc] initWithArray:array];
}

- (NSObject *)nextItem{
	if(_array.count == 0 || !_array){
		return nil;
	}
	if(_pool.count == 0){
		_pool = [[NSMutableArray alloc] initWithArray:_array];
	}
	NSUInteger random = arc4random_uniform((int32_t)_pool.count);
	NSObject *nextItem = [_pool objectAtIndex:random];
	[_pool removeObjectAtIndex:random];
	if(self.delegate){
		if([self.delegate respondsToSelector:@selector(randomPool:removedElement:)]){
			[self.delegate randomPool:self removedElement:nextItem];
		}
	}
	if(_pool.count == 0){
		if(self.delegate){
			if([self.delegate respondsToSelector:@selector(randomPool:removedElement:)]){
				[self.delegate randomPoolDrained:self];
			}
		}
		_pool = [[NSMutableArray alloc] initWithArray:_array];
	}
	return nextItem;
}

@end
