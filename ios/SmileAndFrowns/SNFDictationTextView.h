
#import <UIKit/UIKit.h>

@protocol SNFDicationTextViewDelegate <NSObject>
- (void) dictationRecordingDidEnd;
@end

@interface SNFDictationTextView : UITextView <UITextInput>

@end
