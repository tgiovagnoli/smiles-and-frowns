
#import <Foundation/Foundation.h>

@interface NSSortDescriptor (Additions)

+ (NSSortDescriptor *) ascendingSortWithKey:(NSString *) key;
+ (NSSortDescriptor *) descendingSortWithKey:(NSString *) key;

@end
