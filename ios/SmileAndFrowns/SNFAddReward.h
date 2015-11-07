
#import <UIKit/UIKit.h>
#import "SNFBoard.h"
#import "SNFReward.h"
#import "SNFFormViewController.h"

typedef NS_ENUM(NSInteger,SNFAddRewardCurrency) {
	SNFAddRewardCurrencyTime = 0,
	SNFAddRewardCurrencyMoney = 1,
	SNFAddRewardCurrencyTreat = 2,
	SNFAddRewardCurrencyGoal = 3,
};

@class SNFAddReward;

@protocol SNFAddRewardDelegate <NSObject>
- (void)addRewardIsFinished:(SNFAddReward *)addReward;
@end

@interface SNFAddReward : SNFFormViewController <UITextFieldDelegate>

@property (weak) IBOutlet UISegmentedControl *typeControl;
@property (weak) IBOutlet UILabel *smilesAmountLabel;
@property (weak) IBOutlet UILabel *currencyAmountLabel;
@property (weak) IBOutlet UIStepper *smilesStepper;
@property (weak) IBOutlet UIStepper *currencyStepper;
@property (weak) IBOutlet UITextField *titleField;

@property SNFBoard *board;
@property SNFReward *reward;
@property (weak) NSObject <SNFAddRewardDelegate> *delegate;

@end
