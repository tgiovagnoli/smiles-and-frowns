#import "SNFCoreDataUtil.h"
#import "SNFModel.h"
@implementation SNFCoreDataUtil


- (NSManagedObject *)editOrCreateWithName:(NSString *)name andInfo:(NSDictionary *)info{
	NSManagedObjectContext *context = [SNFModel sharedInstance].managedObjectContext;
	// NSManagedObject *context = [NSEntityDescription insertNewObjectForEntityForName:name inManagedObjectContext:context];
	return nil;
}

@end
