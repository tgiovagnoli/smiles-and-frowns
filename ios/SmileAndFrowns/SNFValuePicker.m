#import "SNFValuePicker.h"

@implementation SNFValuePicker

- (void)viewDidLoad{
	[super viewDidLoad];
	[self.pickerView reloadAllComponents];
	[self decorate];
}

- (void)decorate{
	[SNFFormStyles roundEdgesOnButton:self.doneButton];
	
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

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
	UILabel *pickerLabel = (UILabel *)view;
	if(!pickerLabel){
		pickerLabel = [[UILabel alloc] init];
		[pickerLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:17]];
		pickerLabel.numberOfLines = 3;
		pickerLabel.textAlignment = NSTextAlignmentCenter;
		pickerLabel.textColor = [SNFFormStyles darkGray];
	}
	pickerLabel.text = [_values objectAtIndex:row];
	return pickerLabel;
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
