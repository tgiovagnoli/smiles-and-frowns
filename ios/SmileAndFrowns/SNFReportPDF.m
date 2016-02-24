
#import "SNFReportPDF.h"
#import "SNFReportPDFUserHeader.h"
#import "UIView+LayoutHelpers.h"
#import "SNFReportPDFDetailRow.h"
#import "UIColor+Hex.h"
#import "AppDelegate.h"
#import "HDLabel.h"
#import "HDView.h"

NSString * const SNFReportPDFFinished = @"SNFReportPDFFinished";

@interface SNFReportPDF ()
@property SNFReportPDFUserHeader * userHeader;
@property CGRect creditsFrame;
@end

@implementation SNFReportPDF

- (void) viewDidLoad {
	[super viewDidLoad];
	self.creditsFrame = self.credits.frame;
}

- (void) savePDF {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onProfileImageFinished:) name:SNFReportPDFUserHeaderImageFinished object:nil];
	self.userHeader = [[SNFReportPDFUserHeader alloc] init];
	self.userHeader.user = self.user;
	self.userHeader.board = self.board;
	[self.view addSubview:self.userHeader.view];
}

- (void) onProfileImageFinished:(NSNotification *) notification {
	if(self.dataProviderV1) {
		[self continueAfterProfileLoadedV1];
	} else {
		[self continueAfterProfileLoaded];
	}
}

- (void) continueAfterProfileLoaded {
	if(!self.view.superview) {
		NSLog(@"SNFReportPDF must be on the view hierarchy");
		return;
	}
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString * docs = [paths objectAtIndex:0];
	NSURL * pdfURL = [[NSURL fileURLWithPath:docs] URLByAppendingPathComponent:@"smiles-and-frowns-report.pdf"];
	UIGraphicsBeginPDFContextToFile(pdfURL.path, CGRectZero, nil);
	
	NSLog(@"pdf url: %@",pdfURL);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self startPage:nil removeAllViews:FALSE];
	
	CGFloat pageY = 0;
	NSInteger pad = 20;
	NSInteger dateRowHeight = 40;
	NSInteger detailRowHeight = 100;
	
	//add space for existing user header.
	pageY += self.userHeader.view.height;
	pageY += pad;
	
	//go through each date group for sections.
	for(SNFReportSection * section in self.dataProvider.sections) {
		
		//check if header would be beyond page height.
		if(pageY + (dateRowHeight+pad) > self.view.height) {
			[self.view.layer renderInContext:context];
			[self startPage:context removeAllViews:TRUE];
			pageY = pad;
		}
		
		//check if the date header +  a row is too tall
		else if(pageY + (dateRowHeight+pad) + (detailRowHeight+pad) > self.view.height) {
			[self.view.layer renderInContext:context];
			[self startPage:context removeAllViews:TRUE];
			pageY = pad;
		}
		
		//add date section
		
		HDView * headerView = [[HDView alloc] initWithFrame:CGRectMake(20,pageY,self.view.width-40,dateRowHeight)];
		HDLabel * headerLabel = [[HDLabel alloc] initWithFrame:CGRectMake(10,0,headerView.width-20,dateRowHeight)];
		headerLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
		headerLabel.textColor = [UIColor darkGrayColor];
		headerView.layer.cornerRadius = 4;
		headerView.layer.masksToBounds = TRUE;
		headerView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
		
		//get date label
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.doesRelativeDateFormatting = YES;
		[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
		dateFormatter.locale = [NSLocale currentLocale];
		dateFormatter.dateFormat = @"MM/d/yy";
		
		headerLabel.text = section.sectionHeaderTitle;
		
		pageY += headerLabel.height;
		pageY += pad;
		[headerView addSubview:headerLabel];
		[self.view addSubview:headerView];
		
		
		//go through behavior groups.
		
		NSUInteger rowCount = section.behaviorGroups.count;
		NSInteger i = 0;
		SNFReportPDFDetailRow * row = nil;
		
		for(SNFReportBehaviorGroup2 * behaviorGroup in section.behaviorGroups) {
			i++;
			
			//check if row would be beyond page height.
			if(pageY + (detailRowHeight+pad) > self.view.height) {
				
				[row hideSeperator];
				
				[self.view.layer renderInContext:context];
				[self startPage:context removeAllViews:TRUE];
				pageY = pad;
				
				//insert a date header on top of page.
				[self.view addSubview:headerView];
				headerView.y = pageY;
				pageY += headerView.height;
				pageY += pad;
				
			}
			
			//create row.
			row = [[SNFReportPDFDetailRow alloc] init];
			row.behaviorGroup = behaviorGroup;
			row.view.y = pageY;
			
			//hide seperator if last row.
			if(i == rowCount) {
				[row hideSeperator];
			}
			
			[self.view addSubview:row.view];
			pageY += detailRowHeight;
			pageY += pad;
		}
	}
	
	//final page render
	[self.view.layer renderInContext:context];
	
	//finish pdf
	UIGraphicsEndPDFContext();
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFReportPDFFinished object:nil];
	
	//[self.view removeFromSuperview];
}

- (void) continueAfterProfileLoadedV1 {
	if(!self.view.superview) {
		NSLog(@"SNFReportPDF must be on the view hierarchy");
		return;
	}
	
	NSArray * paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
	NSString * docs = [paths objectAtIndex:0];
	NSURL * pdfURL = [[NSURL fileURLWithPath:docs] URLByAppendingPathComponent:@"smiles-and-frowns-report.pdf"];
	UIGraphicsBeginPDFContextToFile(pdfURL.path, CGRectZero, nil);
	
	NSLog(@"pdf url: %@",pdfURL);
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	[self startPage:nil removeAllViews:FALSE];
	
	CGFloat pageY = 0;
	NSInteger pad = 20;
	NSInteger dateRowHeight = 40;
	NSInteger detailRowHeight = 100;
	
	//add space for existing user header.
	pageY += self.userHeader.view.height;
	pageY += pad;
	
	//go through each date group for sections.
	for(SNFReportDateGroup * section in self.dataProviderV1) {
		
		//check if header would be beyond page height.
		if(pageY + (dateRowHeight+pad) > self.view.height) {
			[self.view.layer renderInContext:context];
			[self startPage:context removeAllViews:TRUE];
			pageY = pad;
		}
		
		//check if the date header +  a row is too tall
		else if(pageY + (dateRowHeight+pad) + (detailRowHeight+pad) > self.view.height) {
			[self.view.layer renderInContext:context];
			[self startPage:context removeAllViews:TRUE];
			pageY = pad;
		}
		
		//add date section
		
		HDView * headerView = [[HDView alloc] initWithFrame:CGRectMake(20,pageY,self.view.width-40,dateRowHeight)];
		HDLabel * headerLabel = [[HDLabel alloc] initWithFrame:CGRectMake(10,0,headerView.width-20,dateRowHeight)];
		headerLabel.font = [UIFont fontWithName:@"Helvetica Neue" size:17];
		headerLabel.textColor = [UIColor darkGrayColor];
		headerView.layer.cornerRadius = 4;
		headerView.layer.masksToBounds = TRUE;
		headerView.backgroundColor = [UIColor colorWithHexString:@"#cccccc"];
		
		//get date label
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		dateFormatter.timeStyle = NSDateFormatterNoStyle;
		dateFormatter.dateStyle = NSDateFormatterMediumStyle;
		dateFormatter.doesRelativeDateFormatting = YES;
		[dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
		dateFormatter.locale = [NSLocale currentLocale];
		dateFormatter.dateFormat = @"MM/d/yy";
		
		headerLabel.text = [dateFormatter stringFromDate:section.date];
		
		pageY += headerLabel.height;
		pageY += pad;
		[headerView addSubview:headerLabel];
		[self.view addSubview:headerView];
		
		//go through behavior groups.
		
		NSUInteger rowCount = section.behaviorGroups.count;
		NSInteger i = 0;
		SNFReportPDFDetailRow * row = nil;
		
		for(SNFReportBehaviorGroup * behaviorGroup in section.behaviorGroups) {
			i++;
			
			//check if row would be beyond page height.
			if(pageY + (detailRowHeight+pad) > self.view.height) {
				
				[row hideSeperator];
				
				[self.view.layer renderInContext:context];
				[self startPage:context removeAllViews:TRUE];
				pageY = pad;
				
				//insert a date header on top of page.
				[self.view addSubview:headerView];
				headerView.y = pageY;
				pageY += headerView.height;
				pageY += pad;
				
			}
			
			//create row.
			row = [[SNFReportPDFDetailRow alloc] init];
			row.behaviorGroupV1 = behaviorGroup;
			row.view.y = pageY;
			
			//hide seperator if last row.
			if(i == rowCount) {
				[row hideSeperator];
			}
			
			[self.view addSubview:row.view];
			pageY += detailRowHeight;
			pageY += pad;
		}
	}
	
	//final page render
	[self.view.layer renderInContext:context];
	
	//finish pdf
	UIGraphicsEndPDFContext();
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SNFReportPDFFinished object:nil];
	
	//[self.view removeFromSuperview];
}

- (void) startPage:(CGContextRef) context removeAllViews:(BOOL) removeAllViews {
	//remove everything.
	if(removeAllViews) {
		for(UIView * view in self.view.subviews) {
			if(view == self.credits) {
				continue;
			}
			[view removeFromSuperview];
		}
	}
	
	//begin page
	UIGraphicsBeginPDFPageWithInfo(CGRectMake(0,0,self.view.width,self.view.height),nil);
}

@end
