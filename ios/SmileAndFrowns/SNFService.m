#import "SNFService.h"


@implementation SNFService

- (NSObject *)responseObjectFromData:(NSData *)data withError:(__autoreleasing NSError **)error{
	NSError *writeError;
	NSObject *dataObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&writeError];
	if(writeError){
		// check if it's a django debug error
		NSString *htmlString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		if(htmlString){
			if([htmlString containsString:@"<!DOCTYPE html>"]){
				*error = [SNFError errorWithCode:SNFErrorCodeDjangoDebugError andMessage:htmlString];
				return nil;
			}
		}
		*error = writeError;
		return nil;
	}
	if([dataObject isKindOfClass:[NSDictionary class]]){
		NSDictionary *r = (NSDictionary *)dataObject;
		if([r objectForKey:@"error"]){
			*error = [SNFError errorWithCode:SNFErrorCodeRemoteError andMessage:[r objectForKey:@"error"]];
			return nil;
		}
	}
	return dataObject;
}

@end
