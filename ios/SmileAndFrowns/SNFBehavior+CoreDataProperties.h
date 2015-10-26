#import "SNFBehavior.h"

@class SNFBoard;
@class SNFFrown;

NS_ASSUME_NONNULL_BEGIN

@interface SNFBehavior (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSString *note;
@property (nullable, nonatomic, retain) NSString *uuid;
@property (nullable, nonatomic, retain) NSNumber *deleted;
@property (nullable, nonatomic, retain) NSNumber *edit_count;
@property (nullable, nonatomic, retain) NSDate *created_date;
@property (nullable, nonatomic, retain) NSDate *updated_date;
@property (nullable, nonatomic, retain) NSNumber *remote_id;
@property (nullable, nonatomic, retain) SNFBoard *board;
@property (nullable, nonatomic, retain) NSSet<SNFSmile *> *smiles;
@property (nullable, nonatomic, retain) NSSet<SNFFrown *> *frowns;

@end

@interface SNFBehavior (CoreDataGeneratedAccessors)

- (void)addSmilesObject:(SNFSmile *)value;
- (void)removeSmilesObject:(SNFSmile *)value;
- (void)addSmiles:(NSSet<SNFSmile *> *)values;
- (void)removeSmiles:(NSSet<SNFSmile *> *)values;

@end

NS_ASSUME_NONNULL_END
