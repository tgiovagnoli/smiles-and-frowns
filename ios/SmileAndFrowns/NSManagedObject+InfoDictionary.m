
#import "NSManagedObject+InfoDictionary.h"
#import "SNFModel.h"

@implementation NSManagedObject (InfoDictionary)

+ (NSString *) primaryLookup {
	return @"uuid";
}

+ (NSDictionary *) keyMappings {
	return @{};
}

+ (NSManagedObject *) editOrCreatefromInfoDictionary:(NSDictionary *) infoDict withContext:(NSManagedObjectContext *) context {
	NSString * className = NSStringFromClass([self class]);
	NSString * primaryKey = [[self class] primaryLookup];
	NSString * infoPrimaryKey = [[[self class] keyMappings] objectForKey:primaryKey];
	NSManagedObject * managedObject = nil;
	
	if([infoDict objectForKey:infoPrimaryKey]) {
		NSFetchRequest * fetchRequest = [[NSFetchRequest alloc] init];
		
		NSEntityDescription * entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
		NSPredicate * predicate = [NSPredicate predicateWithFormat:@"%K==%@", primaryKey, [infoDict objectForKey:infoPrimaryKey]];
		[fetchRequest setPredicate:predicate];
		
		NSError * error;
		NSArray * fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
		
		if(fetchedObjects.count > 0 && !error) {
			managedObject = [fetchedObjects objectAtIndex:0];
		}
	}
	
	if(!managedObject) {
		NSLog(@"creating new instance of %@", className);
		managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
		
		if([infoDict objectForKey:infoPrimaryKey]) {
			[managedObject setValue:[infoDict objectForKey:infoPrimaryKey] forKey:primaryKey];
		}
		
	} else {
		NSLog(@"loading instance of %@", className);
	}
	
	if(managedObject) {
		[managedObject updateWithInfoDict:infoDict andContext:context];
	}
	
	return managedObject;
}

- (void) updateWithInfoDict:(NSDictionary *) info andContext:(NSManagedObjectContext *) context {
	for(NSString * key in info) {
		id value = info[key];
		NSString * mappedKey = key;
		
		NSDictionary * mappings = [[self class] keyMappings];
		if([[mappings allKeysForObject:key] lastObject]) {
			mappedKey = [[mappings allKeysForObject:key] lastObject];
		}
		
		objc_property_t property = class_getProperty([self class], [mappedKey UTF8String]);
		if(!property) {
			continue;
		}
		
		NSString * typeString = [NSString stringWithUTF8String:property_getAttributes(property)];
		NSArray * attributes = [typeString componentsSeparatedByString:@","];
		NSString * typeAttribute = [attributes objectAtIndex:0];
		
		if([typeAttribute hasPrefix:@"T@"]) {
			
			NSString * typeClassName = [typeAttribute substringWithRange:NSMakeRange(3,[typeAttribute length]-4)];
			Class class = NSClassFromString(typeClassName);
			
			if(class == [NSDate class]) {
				value = [self dateFromString:value];
			} else if([class isSubclassOfClass:[NSManagedObject class]]) {
				value = [class editOrCreatefromInfoDictionary:value withContext:context];
			}
		}
		
		if ([self respondsToSelector:NSSelectorFromString(mappedKey)]) {
			NSLog(@"setting value:(%@) forKey:(%@) on (%@)", value, key, NSStringFromClass([self class]));
			[self setValue:value forKey:mappedKey];
		}else{
			@throw [NSException exceptionWithName:@"KeyNotFound" reason:[NSString stringWithFormat:@"Cound not find key (%@) on (%@)", mappedKey, NSStringFromClass([self class])] userInfo:nil];
		}
		
	}
}

- (NSDictionary *) infoDictionary {
	NSDictionary * keyMappings = [[self class] keyMappings];
	NSMutableDictionary * infoDict = [[NSMutableDictionary alloc] init];
	for(NSString * key in keyMappings) {
		id value = [self valueForKey:key];
		if(value) {
			if([value isKindOfClass:[NSDate class]]) {
				value = [self stringFromDate:(NSDate *)value];
			} else if([value respondsToSelector:@selector(infoDictionary)]) {
				value = [value performSelector:@selector(infoDictionary)];
			}
			NSString * insertKey = [keyMappings objectForKey:key];
			[infoDict setObject:value forKey:insertKey];
		}
	}
	return infoDict;
}

- (NSObject *) objectOrNull:(NSObject *) obj {
	if(obj) {
		return obj;
	}
	return [NSNull null];
}

- (NSString *) stringFromDate:(NSDate *) date {
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter stringFromDate:date];
}

- (NSDate *) dateFromString:(NSString *) dateString {
	NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
	// 2015-10-21T21:34:54Z
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter dateFromString:dateString];
}

- (NSArray *) uuidArrayFromManagedObjects:(NSSet *) managedObjects {
	NSMutableArray * uuids = [[NSMutableArray alloc] initWithCapacity:managedObjects.count];
	SEL selector = NSSelectorFromString(@"uuid");
	for(NSObject * mo in managedObjects){
		if([mo respondsToSelector:selector]) {
			[uuids addObject:[mo valueForKey:@"uuid"]];
		}
	}
	return uuids;
}

@end