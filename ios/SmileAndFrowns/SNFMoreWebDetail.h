#import <UIKit/UIKit.h>
#import "UIAlertAction+Additions.h"
#import "UIViewControllerStack.h"

@interface SNFMoreWebDetail : UIViewController <UIWebViewDelegate, UIViewControllerStackUpdating>

@property (weak) IBOutlet UIWebView *webView;
@property (weak) IBOutlet UIButton *closeButton;
@property (weak) IBOutlet UILabel *titleLabel;

- (void)setTitle:(NSString *)title andURL:(NSURL *)url;
- (IBAction)onBack:(UIButton *)sender;

@end
