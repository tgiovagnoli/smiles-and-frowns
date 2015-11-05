#import "SNFReportBehaviorGroup.h"

@implementation SNFReportBehaviorGroup

- (id)init{
	self = [super init];
	self.smiles = [[NSMutableArray alloc] init];
	self.frowns = [[NSMutableArray alloc] init];
	return self;
}

- (BOOL)checkGroupViabilityOnSmile:(SNFSmile *)smile{
	if(![_behaviorUUID isEqualToString:smile.behavior.uuid]){
		return NO;
	}
	if(![_creatorUsername isEqualToString:smile.creator.username]){
		return NO;
	}
	if(![_note isEqualToString:smile.note]){
		return NO;
	}
	if(![_boardUUID isEqualToString:smile.board.uuid]){
		return NO;
	}
	return YES;
}

- (void)createKeysFromSmile:(SNFSmile *)smile{
	_behaviorUUID = smile.behavior.uuid;
	_creatorUsername = smile.creator.username;
	_note = smile.note;
	_boardUUID = smile.board.uuid;
	_type = SNFReportBehaviorGroupTypeSmile;
}

- (BOOL)checkGroupViabilityOnFrown:(SNFFrown *)frown{
	if(![_behaviorUUID isEqualToString:frown.behavior.uuid]){
		return NO;
	}
	if(![_creatorUsername isEqualToString:frown.creator.username]){
		return NO;
	}
	if(![_note isEqualToString:frown.note]){
		return NO;
	}
	if(![_boardUUID isEqualToString:frown.board.uuid]){
		return NO;
	}
	return YES;
}

- (void)createKeysFromFrown:(SNFFrown *)frown{
	_behaviorUUID = frown.behavior.uuid;
	_creatorUsername = frown.creator.username;
	_note = frown.note;
	_boardUUID = frown.board.uuid;
	_type = SNFReportBehaviorGroupTypeFrown;
}

@end
