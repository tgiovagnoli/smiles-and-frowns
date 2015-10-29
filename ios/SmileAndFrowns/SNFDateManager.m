#import "SNFDateManager.h"

static BOOL _locked;

@implementation SNFDateManager


+ (void)initialize{
	[[NSNotificationCenter defaultCenter] addObserver:[self class] selector: @selector(objectContextWillSave:) name: NSManagedObjectContextWillSaveNotification object: nil];
}

+ (void)objectContextWillSave:(NSNotification *)notification{
	if(_locked){
		return;
	}
	NSManagedObjectContext *context = [notification object];
	NSSet *allModified = [context.insertedObjects setByAddingObjectsFromSet:context.updatedObjects];
	NSDate *now = [NSDate date];
	for(NSManagedObject *object in allModified){
		if([object respondsToSelector:NSSelectorFromString(@"updated_date")]){
			[object setValue:now forKey:@"updated_date"];
		}
	}
}

+ (void)lock{
	_locked = YES;
}

+ (void)unlock{
	_locked = NO;
}

@end
