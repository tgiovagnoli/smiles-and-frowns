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

- (NSObject *)objectOrNull:(NSObject *)obj;
- (NSString *)stringFromDate:(NSDate *)date;
- (NSDate *)dateFromString:(NSString *)dateString;
- (NSArray *)uuidArrayFromManagedObjects:(NSSet *)managedObjects;
- (void)updateSyncPropertiesfromDict:(NSDictionary *)infoDict;



+ (NSManagedObject *)editOrCreatefromInfoDictionary:(NSDictionary *)infoDict;
- (void)updateWithInfoDict:(NSDictionary *)info;
- (NSDictionary *)infoDictionary;

@end
