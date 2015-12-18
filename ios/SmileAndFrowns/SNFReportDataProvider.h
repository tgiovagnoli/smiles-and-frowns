
#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportSection.h"

@interface SNFReportDataProvider : NSObject

@property NSInteger maxWeeks;
@property NSMutableArray * sections;

- (id) initWithMaxWeeks:(NSInteger) maxWeeks;
- (void) addSmile:(SNFSmile *) smile;
- (void) addFrown:(SNFFrown *) frown;
- (void) sortSectionsBySectionIndex;

@end
