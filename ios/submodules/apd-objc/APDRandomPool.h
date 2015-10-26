#import <Foundation/Foundation.h>

@class APDRandomPool;

@protocol APDRandomPoolDelegate <NSObject>
@optional
- (void)randomPool:(APDRandomPool *)pool removedElement:(NSObject *)element;
- (void)randomPoolDrained:(APDRandomPool *)pool;
@end

@interface APDRandomPool : NSObject{
	NSMutableArray *_pool;
}

@property (nonatomic) NSArray *array;
@property (weak) NSObject <APDRandomPoolDelegate> *delegate;

- (id)initWithArray:(NSArray *)array;
- (NSObject *)nextItem;

@end
