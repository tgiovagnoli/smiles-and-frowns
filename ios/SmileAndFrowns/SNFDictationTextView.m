
#import "SNFDictationTextView.h"

@implementation SNFDictationTextView

- (void) dictationRecordingDidEnd {
	if(self.delegate) {
		NSObject <SNFDicationTextViewDelegate> * delegate = (NSObject <SNFDicationTextViewDelegate> *)self.delegate;
		[delegate dictationRecordingDidEnd];
	}
}

@end
