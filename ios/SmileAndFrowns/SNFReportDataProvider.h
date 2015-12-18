
#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFReportSection.h"

@interface SNFReportDataProvider : NSObject

@property NSTimeInterval windowStart;
@property NSTimeInterval windowEnd;
@property NSInteger weeks;
@property NSInteger maxWeeks;

@property NSMutableArray * sections;

- (id) initWithWindowStart:(NSTimeInterval) start windowEnd:(NSTimeInterval) end weeks:(NSInteger) weeks maxWeeks:(NSInteger) maxWeeks;
- (void) resetWindowStart:(NSTimeInterval) start windowEnd:(NSTimeInterval) end weeks:(NSInteger) weeks maxWeeks:(NSInteger) maxWeeks;
- (void) addSmile:(SNFSmile *) smile;
- (void) addFrown:(SNFFrown *) frown;
- (void) moveWindow;
- (BOOL) shouldContinue;
- (BOOL) shouldMoveWindow:(NSTimeInterval) smileFrownCreatedDate;
- (void) sortSectionsByWeek;

@end
