#import "NSManagedObject+InfoDictionary.h"
#import "SNFModel.h"

@implementation NSManagedObject (InfoDictionary)


+ (NSString *)primaryLookup{
	return @"uuid";
}

+ (NSDictionary *)keyMappings{
	return @{@"uuid": @"uuid"};
}

+ (NSManagedObject *)editOrCreatefromInfoDictionary:(NSDictionary *)infoDict withContext:(NSManagedObjectContext *)context{
	NSString *className = NSStringFromClass([self class]);
	NSString *primaryKey = [[self class] primaryLookup];
	NSString *infoPrimaryKey = [[[self class] keyMappings] objectForKey:primaryKey];
	
	NSManagedObject *managedObject;
	if([infoDict objectForKey:infoPrimaryKey]){
		NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
		NSEntityDescription *entity = [NSEntityDescription entityForName:className inManagedObjectContext:context];
		[fetchRequest setEntity:entity];
		
		NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K==%@", primaryKey, [infoDict objectForKey:infoPrimaryKey]];
		[fetchRequest setPredicate:predicate];
	
		NSError *error;
		NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
		
		if(fetchedObjects.count > 0 && !error){
			managedObject = [fetchedObjects objectAtIndex:0];
		}
	}
	
	if(!managedObject){
		managedObject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
		if([infoDict objectForKey:infoPrimaryKey]){
			[managedObject setValue:[infoDict objectForKey:infoPrimaryKey] forKey:primaryKey];
		}
		NSLog(@"creating new instance of %@", className);
	}else{
		NSLog(@"loading instance of %@", className);
	}
	
	if(managedObject){
		[managedObject updateWithInfoDict:infoDict andContext:context];
	}
	
	return managedObject;
}

- (void)updateWithInfoDict:(NSDictionary *)info andContext:(NSManagedObjectContext *)context{
	NSDictionary *keyMappings = [[self class] keyMappings];
	unsigned int numOfProperties;
	objc_property_t *properties = class_copyPropertyList([self class], &numOfProperties);
	for(int i=0; i<numOfProperties; i++) {
		objc_property_t property = properties[i];
		NSString *propertyName = [NSString stringWithCString:property_getName(property) encoding:NSASCIIStringEncoding];
		PropertyType type = [self typeForProperty:property];
		NSString *getKey = [keyMappings objectForKey:propertyName];
		NSObject *insertValue = [info objectForKey:getKey];
		if(insertValue){
			if(type == PropertyTypeNSDate){
				insertValue = [self dateFromString:(NSString *)insertValue];
			}else if(type == PropertyTypeClass){
				NSDictionary *popVal = (NSDictionary *)insertValue;
				insertValue = [self populateInfoFromClassName:[self classNameForProperty:property] context:context andInfo:popVal];
			}
			[self setValue:insertValue forKey:propertyName];
		}
	}
	free(properties);
}

- (NSDictionary *)infoDictionary{
	NSDictionary *keyMappings = [[self class] keyMappings];
	NSMutableDictionary *infoDict = [[NSMutableDictionary alloc] init];
	for(NSString *key in keyMappings){
		NSObject *value = [self valueForKey:key];
		if(value){
			if([value isKindOfClass:[NSDate class]]){
				value = [self stringFromDate:(NSDate *)value];
			}else if([value respondsToSelector:@selector(infoDictionary)]){
				value = [value performSelector:@selector(infoDictionary)];
			}
			NSString *insertKey = [keyMappings objectForKey:key];
			[infoDict setObject:value forKey:insertKey];
		}
	}
	return infoDict;
}

- (NSObject *)objectOrNull:(NSObject *)obj{
	if(obj){
		return obj;
	}
	return [NSNull null];
}

- (NSString *)stringFromDate:(NSDate *)date{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter stringFromDate:date];
}

- (NSDate *)dateFromString:(NSString *)dateString{
	NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
	// 2015-10-21T21:34:54Z
	[formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
	[formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
	return [formatter dateFromString:dateString];
}

- (NSArray *)uuidArrayFromManagedObjects:(NSSet *)managedObjects{
	NSMutableArray *uuids = [[NSMutableArray alloc] initWithCapacity:managedObjects.count];
	SEL selector = NSSelectorFromString(@"uuid");
	for(NSObject *mo in managedObjects){
		if([mo respondsToSelector:selector]){
			[uuids addObject:[mo valueForKey:@"uuid"]];
		}
	}
	return uuids;
}

- (PropertyType)typeForProperty:(objc_property_t)property{
	const char *type = property_getAttributes(property);
	
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	NSString *propertyType = [typeAttribute substringFromIndex:1];
	const char *rawPropertyType = [propertyType UTF8String];
	
	PropertyType returnType = PropertyTypeUnknown;
	if(strcmp(rawPropertyType, @encode(float)) == 0){
		return PropertyTypeFloat;
	}else if (strcmp(rawPropertyType, @encode(int)) == 0){
		return PropertyTypeInt;
	}else if (strcmp(rawPropertyType, @encode(double)) == 0 || strcmp(rawPropertyType, @encode(CGFloat)) == 0){
		return PropertyTypeDouble;
	}else if (strcmp(rawPropertyType, @encode(BOOL)) == 0){
		return PropertyTypeBool;
	}else if (strcmp(rawPropertyType, @encode(id)) == 0){
		return PropertyTypeClass;
	}else if (strcmp(rawPropertyType, @encode(long)) == 0 || strcmp(rawPropertyType, @encode(NSInteger)) == 0){
		returnType = PropertyTypeClass;
	}
	
	if([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1){
		NSString *typeClassName = [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
		Class typeClass = NSClassFromString(typeClassName);
		
		if([typeClassName isEqualToString:@"NSSet"]){
			returnType = PropertyTypeNSSet;
		}else if([typeClassName isEqualToString:@"NSNumber"]){
			returnType = PropertyTypeNSNumber;
		}else if([typeClassName isEqualToString:@"NSDate"]){
			returnType = PropertyTypeNSDate;
		}else if([typeClassName isEqualToString:@"NSString"]){
			returnType = PropertyTypeNSString;
		}else if(typeClass != nil){
			returnType = PropertyTypeClass;
		}
	}
	return returnType;
}

- (NSString *)classNameForProperty:(objc_property_t)property{
	const char *type = property_getAttributes(property);
	NSString *typeString = [NSString stringWithUTF8String:type];
	NSArray *attributes = [typeString componentsSeparatedByString:@","];
	NSString *typeAttribute = [attributes objectAtIndex:0];
	if([typeAttribute hasPrefix:@"T@"] && [typeAttribute length] > 1){
		return [typeAttribute substringWithRange:NSMakeRange(3, [typeAttribute length]-4)];
	}
	return nil;
}

- (NSManagedObject *)populateInfoFromClassName:(NSString *)className context:(NSManagedObjectContext*)context andInfo:(NSDictionary *)info{
	Class ManagedObjectClass = NSClassFromString(className);
	return [ManagedObjectClass editOrCreatefromInfoDictionary:info withContext:context];
}

- (NSArray *)attributesOfProp:(objc_property_t)prop{
	const char * propAttr = property_getAttributes(prop);
	NSString *propString = [NSString stringWithUTF8String:propAttr];
	NSArray *attrArray = [propString componentsSeparatedByString:@","];
	return attrArray;
}

@end
