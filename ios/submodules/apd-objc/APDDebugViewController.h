#import <UIKit/UIKit.h>

@class APDDebugViewController;

@protocol APDDebugViewControllerDelegate <NSObject>
@optional
- (void)debugViewControllerIsDone:(APDDebugViewController *)debugViewController;
@end


@interface APDDebugViewControllerItem : NSObject
@property SEL selector;
@property NSString *name;
@end

@interface APDDebugViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>{
	
}

@property (weak) IBOutlet UITableView *tableView;
@property (weak) NSObject <APDDebugViewControllerDelegate> *delegate;
@property NSMutableArray *items;


+ (APDDebugViewControllerItem *)viewControllerItemWithName:(NSString *)name andSelector:(SEL)selector;
- (void)insertItemWithName:(NSString *)name andSelector:(SEL)selector;
- (IBAction)onClose:(id)sender;

@end
