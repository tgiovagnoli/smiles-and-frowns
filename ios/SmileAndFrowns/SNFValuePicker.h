#import <UIKit/UIKit.h>

@class SNFValuePicker;

@protocol SNFValuePickerDelegate <NSObject>
- (void)valuePicker:(SNFValuePicker *)valuePicker changedValue:(NSString *)value;
- (void)valuePickerFinished:(SNFValuePicker *)valuePicker;
@end

@interface SNFValuePicker : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (weak) IBOutlet UIPickerView *pickerView;
@property (weak) IBOutlet UIButton *doneButton;
@property (nonatomic) NSArray *values;
@property (nonatomic) NSString *selectedValue;
@property (weak) NSObject <SNFValuePickerDelegate> *delegate;
@property NSInteger tag;

- (IBAction)onDone:(UIButton *)sender;

@end
