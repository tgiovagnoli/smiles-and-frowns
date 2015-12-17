
#import "SNFReporting.h"
#import "SNFFormStyles.h"
#import "SNFBoardDetailHeader.h"
#import "SNFReportPDF.h"
#import "UIViewController+Alerts.h"
#import "SNFReportPDFUserHeader.h"
#import "SNFViewController.h"
#import "AppDelegate.h"
#import "NSTimer+Blocks.h"

@interface SNFReporting ()
@property SNFReportPDF * pdf;
@property UIActivityViewController * activityViewController;
@end

@implementation SNFReporting

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_ascending = NO;
	
	[self.reportTable registerClass:[SNFReportingSectionHeader class] forHeaderFooterViewReuseIdentifier:@"SNFReportingSectionHeader"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportingSectionHeader" bundle:nil] forCellReuseIdentifier:@"SNFReportingSectionHeader"];
	
	[self.reportTable registerClass:[SNFReportCellSmileFrown class] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportCellSmileFrown" bundle:nil] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	
	NSMutableString * title = [[NSMutableString alloc] init];
	
	if(self.user.first_name) {
		[title appendString:self.user.first_name];
	}
	
	if(self.user.last_name) {
		[title appendString:@" "];
		[title appendString:self.user.last_name];
	}
	
	if(title.length > 0) {
		self.titleLabel.text = title;
	} else {
		self.titleLabel.text = @"Reporting";
	}
	
	[SNFFormStyles roundEdgesOnButton:self.exportButton];
	[SNFFormStyles updateFontOnSegmentControl:self.filterType];
	
	[self updateUI];
}

- (void) dealloc {
	self.pdf = nil;
}

- (void)updateUI{
	[self reloadReport];
}

- (void)reloadReport{
	if(self.user && self.board){
		SNFReportGeneration *reportGeneration = [[SNFReportGeneration alloc] init];
		switch ((SNFReportingFilter)self.filterType.selectedSegmentIndex) {
			case SNFReportingFilterCurrentBoard:
				_reportData = [reportGeneration smilesFrownsReportForUser:self.user board:self.board ascending:_ascending];
				break;
			case SNFReportingFilterAllBoards:
				_reportData = [reportGeneration smilesFrownsReportForUser:self.user board:nil ascending:_ascending];
				break;
		}
	}
	[self.reportTable reloadData];
}

- (void)setBoard:(SNFBoard *)board{
	_board = board;
	[self updateUI];
}

- (void)setUser:(SNFUser *)user{
	_user = user;
	[self updateUI];
}

- (IBAction)onCancel:(UIButton *)sender{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	SNFReportDateGroup *dateGroup = [_reportData objectAtIndex:section];
	return dateGroup.behaviorGroups.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return _reportData.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
	return 85.0;
}

- (IBAction)onFilterChange:(UISegmentedControl *)sender{
	[self reloadReport];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	SNFReportDateGroup * dateGroup = [_reportData objectAtIndex:indexPath.section];
	SNFReportBehaviorGroup * behaviorGroup = [dateGroup.behaviorGroups objectAtIndex:indexPath.row];
	SNFReportCellSmileFrown * cell = [self.reportTable dequeueReusableCellWithIdentifier:@"SNFReportCellSmileFrown"];
	cell.behaviorGroup = behaviorGroup;
	return cell;
}

- (UIView *) tableView:(UITableView *) tableView viewForHeaderInSection:(NSInteger) section {
	SNFReportDateGroup * dateGroup = [_reportData objectAtIndex:section];
	
	NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
	dateFormatter.timeStyle = NSDateFormatterNoStyle;
	dateFormatter.dateStyle = NSDateFormatterMediumStyle;
	dateFormatter.doesRelativeDateFormatting = YES;
	[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
	dateFormatter.locale = [NSLocale currentLocale];
	dateFormatter.dateFormat = @"MM/d/yy";
	
	SNFBoardDetailHeader * header = [[SNFBoardDetailHeader alloc] init];
	header.textLabel.text = [dateFormatter stringFromDate:dateGroup.date];
	
	return header;
}

- (IBAction)onChangeAscending:(UIButton *)sender{
	_ascending = !_ascending;
	[self reloadReport];
}

- (IBAction) onExport:(id) sender {
	if(_reportData.count < 1) {
		
		[self displayOKAlertWithTitle:@"Sorry" message:@"Nothing to export." completion:nil];
		return;
	}
	
	[MBProgressHUD showHUDAddedTo:self.view animated:TRUE];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPDFFinished:) name:SNFReportPDFFinished object:nil];
	
	self.pdf = [[SNFReportPDF alloc] init];
	self.pdf.reportData = _reportData;
	self.pdf.user = self.user;
	
	if(self.filterType.selectedSegmentIndex != SNFReportingFilterAllBoards) {
		self.pdf.board = self.board;
	}
	
	[[AppDelegate instance].window.rootViewController.view insertSubview:self.pdf.view atIndex:0];
	[self.pdf savePDF];
	
}

- (void) onPDFFinished:(id) sender {
	[NSTimer scheduledTimerWithTimeInterval:.2 block:^{
		[self.pdf.view removeFromSuperview];
	} repeats:FALSE];
	
	[MBProgressHUD hideHUDForView:self.view animated:TRUE];
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, TRUE);
	NSString * docs = [paths objectAtIndex:0];
	NSURL * pdf = [[NSURL fileURLWithPath:docs] URLByAppendingPathComponent:@"smiles-and-frowns-report.pdf"];
	
	if(![[NSFileManager defaultManager] fileExistsAtPath:pdf.path]) {
		[NSTimer scheduledTimerWithTimeInterval:.2 block:^{
			[self onPDFFinished:nil];
		} repeats:FALSE];
	}
	
	__weak SNFReporting * weakself = self;
	
	self.activityViewController = [[UIActivityViewController alloc] initWithActivityItems:@[pdf] applicationActivities:nil];
	
	if([self.activityViewController respondsToSelector:@selector(completionHandler)]) {
		//NSLog(@"completionHandler");
		self.activityViewController.completionHandler = ^(NSString *activityType, BOOL completed){
			weakself.activityViewController = nil;
		};
	}
	
	else if([self.activityViewController respondsToSelector:@selector(completionWithItemsHandler)]) {
		//NSLog(@"completionWithItemsHandler");
		self.activityViewController.completionWithItemsHandler = ^(NSString *activityType, BOOL completed, NSArray *returnedItems, NSError *activityError){
			weakself.activityViewController = nil;
		};
	}
	
	self.activityViewController.modalPresentationStyle = UIModalPresentationPopover;
	self.activityViewController.popoverPresentationController.sourceView = self.exportButton;
	self.activityViewController.popoverPresentationController.backgroundColor = [SNFFormStyles darkSandColor];
	self.activityViewController.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionAny;
	self.activityViewController.popoverPresentationController.sourceRect = CGRectMake(self.exportButton.width/2,self.exportButton.width/2,5,5);
	
	[self presentViewController:self.activityViewController animated:TRUE completion:nil];
}

- (void) popoverControllerDidDismissPopover:(UIPopoverController *)popoverController {
	
}

@end
