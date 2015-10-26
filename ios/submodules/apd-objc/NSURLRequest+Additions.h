
#import <Foundation/Foundation.h>

@interface NSURLRequest (GWAdditions)
+ (BOOL) allowsAnyHTTPSCertificateForHost:(NSString *) host;

//Returns an NSURLRequest prepared for an HTTP file upload using standard
//multipart/form POST data. http://www.cocoadev.com/index.pl?HTTPFileUpload
+ (NSMutableURLRequest *) fileUploadRequestWithURL:(NSURL *) url data:(NSData *) data fileKey:(NSString *) fileKey fileName:(NSString *) fileName variables:(NSDictionary *) variables;

//returns a POST request with data encoded like a standard web form. (application/x-www-form-urlencoded)
+ (NSMutableURLRequest *) formURLEncodedPostRequestWithURL:(NSURL *) url variables:(NSDictionary *) variables;

@end
