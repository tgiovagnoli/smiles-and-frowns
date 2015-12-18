
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, SNFReportBehaviorGroup2Type) {
	SNFReportBehaviorGroup2TypeSmile,
	SNFReportBehaviorGroup2TypeFrown
};

@interface SNFReportBehaviorGroup2 : NSObject

@property SNFReportBehaviorGroup2Type type;
@property NSString * behaviorUUID;
@property NSMutableArray * objects;

- (id) initWithBehaviorUUID:(NSString *) behaviorUUID;

@end
