#import "SNFValuePicker.h"

@implementation SNFValuePicker

- (void)viewDidLoad{
	[super viewDidLoad];
	[self.pickerView reloadAllComponents];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
	return _values.count;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
	return 1;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
	return [_values objectAtIndex:row];
}

- (void)setValues:(NSArray *)values{
	_values = values;
	[self.pickerView reloadAllComponents];
}

- (void)setSelectedValue:(NSString *)selectedValue{
	NSInteger i=0;
	for(NSString *val in _values){
		if([val isEqualToString:selectedValue]){
			[self.pickerView selectRow:i inComponent:0 animated:NO];
			break;
		}
		i++;
	}
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
	if(self.delegate){
		NSString *val = [_values objectAtIndex:row];
		[self.delegate valuePicker:self changedValue:val];
	}
}

- (IBAction)onDone:(UIButton *)sender{
	if(self.delegate){
		[self.delegate valuePickerFinished:self];
	}
}



@end
