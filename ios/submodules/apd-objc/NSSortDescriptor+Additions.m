
#import "NSSortDescriptor+Additions.h"

@implementation NSSortDescriptor (Additions)

+ (NSSortDescriptor *) ascendingSortWithKey:(NSString *) key; {
	return [NSSortDescriptor sortDescriptorWithKey:key ascending:TRUE];
}

+ (NSSortDescriptor *) descendingSortWithKey:(NSString *) key; {
	return [NSSortDescriptor sortDescriptorWithKey:key ascending:FALSE];
}


@end
