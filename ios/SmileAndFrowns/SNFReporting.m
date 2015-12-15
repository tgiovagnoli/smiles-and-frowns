
#import "SNFReporting.h"
#import "SNFFormStyles.h"
#import "SNFBoardDetailHeader.h"

@implementation SNFReporting

- (void)viewDidLoad{
	[super viewDidLoad];
	
	_ascending = NO;
	
	[self.reportTable registerClass:[SNFReportingSectionHeader class] forHeaderFooterViewReuseIdentifier:@"SNFReportingSectionHeader"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportingSectionHeader" bundle:nil] forCellReuseIdentifier:@"SNFReportingSectionHeader"];
	
	[self.reportTable registerClass:[SNFReportCellSmileFrown class] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportCellSmileFrown" bundle:nil] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	
	if(self.board.title) {
		self.titleLabel.text = self.board.title;
	} else {
		self.titleLabel.text = @"Reporting";
	}
	
	[SNFFormStyles roundEdgesOnButton:self.exportButton];
	[SNFFormStyles updateFontOnSegmentControl:self.filterType];
	
	[self updateUI];
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
//	NSArray * topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFReportingSectionHeader" owner:nil options:nil];
//	SNFReportingSectionHeader * sectionHeader = [topLevelObjects objectAtIndex:0];
//	sectionHeader.dateGroup =
//	sectionHeader.contentView.backgroundColor = [SNFFormStyles darkSandColor];
	
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

@end
