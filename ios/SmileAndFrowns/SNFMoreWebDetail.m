#import "SNFMoreWebDetail.h"
#import "SNFViewController.h"
#import "AppDelegate.h"

@implementation SNFMoreWebDetail

- (BOOL) shouldResizeFrameForStackPush:(UIViewControllerStack *)viewStack {
	return YES;
}

- (IBAction)onBack:(UIButton *)sender{
	[[SNFViewController instance].viewControllerStack popViewControllerAnimated:YES];
}

- (void)setTitle:(NSString *)title andURL:(NSURL *)url{
	[MBProgressHUD showHUDAddedTo:self.view animated:YES];
	self.titleLabel.text = title;
	[self.webView loadRequest:[NSURLRequest requestWithURL:url]];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView{
	[MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
	[MBProgressHUD hideHUDForView:self.view animated:YES];
	UIAlertController *alert = [UIAlertController  alertControllerWithTitle:@"Sorry" message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
	[alert addAction:[UIAlertAction OKAction]];
	[[AppDelegate rootViewController] presentViewController:alert animated:YES completion:nil];
}

@end
