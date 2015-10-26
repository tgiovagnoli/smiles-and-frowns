
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSBundle (NibLoading)

- (id) loadViewNibNamed:(NSString *) nibName;
- (id) loadViewNibNamed:(NSString *) nibName owner:(id) owner options:(NSDictionary *) options;

- (id) loadViewNibNamedWithDeviceIdiom:(NSString *) nibName;
- (id) loadViewNibNamedWithDeviceIdiom:(NSString *) nibName owner:(id) owner options:(NSDictionary *) options;

@end
