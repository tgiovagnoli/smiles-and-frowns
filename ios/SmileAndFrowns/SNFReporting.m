#import "SNFReporting.h"

@implementation SNFReporting

- (void)viewDidLoad{
	[super viewDidLoad];
	
	[self.reportTable registerClass:[SNFReportingSectionHeader class] forHeaderFooterViewReuseIdentifier:@"SNFReportingSectionHeader"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportingSectionHeader" bundle:nil] forCellReuseIdentifier:@"SNFReportingSectionHeader"];
	
	[self.reportTable registerClass:[SNFReportCellSmileFrown class] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	[self.reportTable registerNib:[UINib nibWithNibName:@"SNFReportCellSmileFrown" bundle:nil] forCellReuseIdentifier:@"SNFReportCellSmileFrown"];
	
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
				_reportData = [reportGeneration smilesFrownsReportForUser:self.user board:self.board ascending:YES];
				break;
			case SNFReportingFilterAllBoards:
				_reportData = [reportGeneration smilesFrownsReportForUser:self.user board:nil ascending:YES];
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
	SNFReportDateGroup *dateGroup = [_reportData objectAtIndex:indexPath.section];
	SNFReportBehaviorGroup *behaviorGroup = [dateGroup.behaviorGroups objectAtIndex:indexPath.row];
	SNFReportCellSmileFrown *cell = [self.reportTable dequeueReusableCellWithIdentifier:@"SNFReportCellSmileFrown"];
	cell.behaviorGroup = behaviorGroup;
	return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
	NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:@"SNFReportingSectionHeader" owner:nil options:nil];
	SNFReportingSectionHeader *sectionHeader = [topLevelObjects objectAtIndex:0];
	sectionHeader.dateGroup = [_reportData objectAtIndex:section];
	return sectionHeader;
}

@end
