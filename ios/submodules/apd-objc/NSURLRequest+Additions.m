
#import "NSURLRequest+Additions.h"

@implementation NSURLRequest (GWAdditions)

+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString*) host; {
	return TRUE;
}

+ (NSMutableURLRequest *) fileUploadRequestWithURL:(NSURL *) url data:(NSData *) data fileKey:(NSString *) fileKey fileName:(NSString *) fileName variables:(NSDictionary *) variables {
	NSMutableURLRequest * urlRequest = [[NSMutableURLRequest alloc] initWithURL:url];
	[urlRequest setHTTPMethod:@"POST"];
	
	NSMutableData * postData = [NSMutableData data];
	NSString * myboundary = @"14737809831466499882746641449";
	NSString * contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",myboundary];
	[urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	if(data) {
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", fileKey, fileName] dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
		[postData appendData:[NSData dataWithData:data]];
	}
	
	if(variables.count > 0) {
		for(NSString * key in variables) {
			NSString * parameterValue = [variables objectForKey:key];
			[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
			[postData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n%@",key,parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
		}
	} else {
		[postData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",myboundary] dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
	NSString * postLength = [NSString stringWithFormat:@"%lu",(unsigned long)postData.length];
	[urlRequest setValue:postLength forHTTPHeaderField:@"Content-Length"];
	[urlRequest setHTTPBody:postData];
	
	return urlRequest;
}

+ (NSMutableURLRequest *) formURLEncodedPostRequestWithURL:(NSURL *) url variables:(NSDictionary *) variables {
	NSMutableURLRequest * request = [[NSMutableURLRequest alloc] initWithURL:url];
	
	NSMutableArray * vals = [[NSMutableArray alloc] init];
	for(NSString * key in variables) {
		[vals addObject:[NSString stringWithFormat:@"%@=%@", key, [variables objectForKey:key]]];
	}
	
	NSString * stringValues = [vals componentsJoinedByString:@"&"];
	NSData * requestData = [NSData dataWithBytes:[stringValues UTF8String] length:[stringValues length]];
	
	[request setHTTPMethod:@"POST"];
	[request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"content-type"];
	[request setHTTPBody:requestData];
	
	return request;
}

@end
