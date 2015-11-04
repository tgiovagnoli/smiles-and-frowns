
#import "UIViewController+Alerts.h"
#import "UIAlertAction+Additions.h"

@implementation UIViewController (Alerts)

- (void) displayOKAlertWithTitle:(NSString *) title message:(NSString *) msg completion:(void(^)(UIAlertAction *action)) completion; {
	UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction OKActionWithCompletion:^(UIAlertAction *action) {
		if(completion) {
			return completion(action);
		}
		return;
	}]];
	[self presentViewController:alert animated:TRUE completion:nil];
}

@end
