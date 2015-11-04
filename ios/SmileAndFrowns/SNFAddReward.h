#import <UIKit/UIKit.h>

@interface SNFAddReward : UIViewController <UITextFieldDelegate>

@property (weak) IBOutlet UISegmentedControl *typeControl;
@property (weak) IBOutlet UILabel *smilesAmountLabel;
@property (weak) IBOutlet UILabel *currencyAmountLabel;
@property (weak) IBOutlet UIStepper *smilesStepper;
@property (weak) IBOutlet UIStepper *currencyStepper;
@property (weak) IBOutlet UITextField *titleField;

- (IBAction)onSmileAmountUpdate:(UIStepper *)sender;
- (IBAction)onCurrencyAmountUpdate:(UIStepper *)sender;
- (IBAction)onTypeUpdate:(UISegmentedControl *)sender;



@end
