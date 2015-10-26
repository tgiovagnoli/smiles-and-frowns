#import "APDDebugViewController.h"

@implementation APDDebugViewControllerItem

@end

@implementation APDDebugViewController

- (id)init{
	self = [super init];
	self.items = [[NSMutableArray alloc] init];
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
	self = [super initWithCoder:aDecoder];
	self.items = [[NSMutableArray alloc] init];
	return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
	self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
	self.items = [[NSMutableArray alloc] init];
	return self;
}

- (void)insertItemWithName:(NSString *)name andSelector:(SEL)selector{
	APDDebugViewControllerItem *item = [[APDDebugViewControllerItem alloc] init];
	item.name = name;
	item.selector = selector;
	[self.items addObject:item];
	[self.tableView reloadData];
}

+ (APDDebugViewControllerItem *)viewControllerItemWithName:(NSString *)name andSelector:(SEL)selector{
	APDDebugViewControllerItem *item = [[APDDebugViewControllerItem alloc] init];
	item.name = name;
	item.selector = selector;
	return item;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	UITableViewCell *cell = [[UITableViewCell alloc] init];
	APDDebugViewControllerItem *item = [self.items objectAtIndex:indexPath.row];
	cell.textLabel.text = item.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	APDDebugViewControllerItem *item = [self.items objectAtIndex:indexPath.row];
	if([self respondsToSelector:item.selector]){
		[self performSelectorOnMainThread:item.selector withObject:nil waitUntilDone:YES];
	}
}

- (IBAction)onClose:(id)sender{
	if(self.delegate){
		if([self.delegate respondsToSelector:@selector(debugViewControllerIsDone:)]){
			[self.delegate debugViewControllerIsDone:self];
		}
	}
}

@end
