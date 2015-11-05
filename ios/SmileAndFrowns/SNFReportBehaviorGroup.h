#import <Foundation/Foundation.h>
#import "SNFSmile.h"
#import "SNFFrown.h"
#import "SNFBehavior.h"
#import "SNFUser.h"
#import "SNFBoard.h"

typedef NS_ENUM(NSInteger, SNFReportBehaviorGroupType){
	SNFReportBehaviorGroupTypeSmile,
	SNFReportBehaviorGroupTypeFrown
};

@interface SNFReportBehaviorGroup : NSObject{
	NSString *_behaviorUUID;
	NSString *_boardUUID;
	NSString *_note;
	NSString *_creatorUsername;
}

@property NSMutableArray <SNFSmile*> *smiles;
@property NSMutableArray <SNFFrown*> *frowns;
@property (readonly) SNFReportBehaviorGroupType type;

- (void)createKeysFromSmile:(SNFSmile *)smile;
- (void)createKeysFromFrown:(SNFFrown *)frown;
- (BOOL)checkGroupViabilityOnSmile:(SNFSmile *)smile;
- (BOOL)checkGroupViabilityOnFrown:(SNFFrown *)frown;

@end
