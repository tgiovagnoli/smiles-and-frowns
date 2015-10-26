#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, PropertyType){
	PropertyTypeUnknown,
	PropertyTypeFloat,
	PropertyTypeInt,
	PropertyTypeDouble,
	PropertyTypeBool,
	PropertyTypeClass,
	// specific known core data types
	PropertyTypeNSSet,
	PropertyTypeNSNumber,
	PropertyTypeNSString,
	PropertyTypeNSDate
};



@interface NSManagedObject (InfoDictionary)

+ (NSDictionary *)keyMappings;
+ (NSString *)primaryLookup;
+ (NSManagedObject *)editOrCreatefromInfoDictionary:(NSDictionary *)infoDict withContext:(NSManagedObjectContext *)context;

- (void)updateWithInfoDict:(NSDictionary *)info andContext:(NSManagedObjectContext *)context;
- (NSDictionary *)infoDictionary;
- (NSObject *)objectOrNull:(NSObject *)obj;
- (NSString *)stringFromDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)dateString;
- (NSArray *)uuidArrayFromManagedObjects:(NSSet *)managedObjects;



@end
