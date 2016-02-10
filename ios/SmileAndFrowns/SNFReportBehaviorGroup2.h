
#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"

typedef NS_ENUM(NSInteger, SNFReportBehaviorGroup2Type) {
	SNFReportBehaviorGroup2TypeSmile,
	SNFReportBehaviorGroup2TypeFrown
};

@interface SNFReportBehaviorGroup2 : NSObject

@property SNFReportBehaviorGroup2Type type;
@property NSString * behaviorUUID;
@property NSMutableArray * objects;
@property NSMutableString * notes;

- (id) initWithBehaviorUUID:(NSString *) behaviorUUID;
- (void) addSmile:(SNFSmile *) object;
- (void) addFrown:(SNFFrown *) object;

@end
