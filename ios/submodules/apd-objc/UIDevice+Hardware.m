
#import "UIDevice+Hardware.h"
#import <sys/utsname.h>

@implementation UIDevice (Hardware)

- (BOOL) isIpad; {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad;
}

- (BOOL) isIphone; {
	return [UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone;
}

- (BOOL) isSimulator; {
	return [[self deviceName] isEqualToString:@"Simulator"];
}

- (NSString *) deviceName {
	struct utsname systemInfo;
	uname(&systemInfo);
	NSString * code = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
	static NSDictionary* deviceNamesByCode = nil;
	if(!deviceNamesByCode) {
		deviceNamesByCode = @{
			@"i386"      :@"Simulator",
			@"x86_64"    :@"Simulator",
			@"iPod1,1"   :@"iPod Touch",      // (Original)
			@"iPod2,1"   :@"iPod Touch",      // (Second Generation)
			@"iPod3,1"   :@"iPod Touch",      // (Third Generation)
			@"iPod4,1"   :@"iPod Touch",      // (Fourth Generation)
			@"iPhone1,1" :@"iPhone",          // (Original)
			@"iPhone1,2" :@"iPhone",          // (3G)
			@"iPhone2,1" :@"iPhone",          // (3GS)
			@"iPad1,1"   :@"iPad",            // (Original)
			@"iPad2,1"   :@"iPad 2",          //
			@"iPad3,1"   :@"iPad",            // (3rd Generation)
			@"iPhone3,1" :@"iPhone 4",        // (GSM)
			@"iPhone3,3" :@"iPhone 4",        // (CDMA/Verizon/Sprint)
			@"iPhone4,1" :@"iPhone 4S",       //
			@"iPhone5,1" :@"iPhone 5",        // (model A1428, AT&T/Canada)
			@"iPhone5,2" :@"iPhone 5",        // (model A1429, everything else)
			@"iPad3,4"   :@"iPad",            // (4th Generation)
			@"iPad2,5"   :@"iPad Mini",       // (Original)
			@"iPhone5,3" :@"iPhone 5c",       // (model A1456, A1532 | GSM)
			@"iPhone5,4" :@"iPhone 5c",       // (model A1507, A1516, A1526 (China), A1529 | Global)
			@"iPhone6,1" :@"iPhone 5s",       // (model A1433, A1533 | GSM)
			@"iPhone6,2" :@"iPhone 5s",       // (model A1457, A1518, A1528 (China), A1530 | Global)
			@"iPhone7,1" :@"iPhone 6 Plus",   //
			@"iPhone7,2" :@"iPhone 6",        //
			@"iPad4,1"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Wifi
			@"iPad4,2"   :@"iPad Air",        // 5th Generation iPad (iPad Air) - Cellular
			@"iPad4,4"   :@"iPad Mini",       // (2nd Generation iPad Mini - Wifi)
			@"iPad4,5"   :@"iPad Mini"        // (2nd Generation iPad Mini - Cellular)
		};
	}
	
	NSString * deviceName = [deviceNamesByCode objectForKey:code];
	
	if(!deviceName) {
		// Not found on database. At least guess main device type from string contents:
		if([code rangeOfString:@"iPod"].location != NSNotFound) {
			deviceName = @"iPod Touch";
		} else if([code rangeOfString:@"iPad"].location != NSNotFound) {
			deviceName = @"iPad";
		} else if([code rangeOfString:@"iPhone"].location != NSNotFound){
			deviceName = @"iPhone";
		}
	}
	
	return deviceName;
}

- (BOOL) isIphone4 {
	if([self isSimulator]) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		if(bounds.size.width == 320 && bounds.size.height == 480) {
			return TRUE;
		}
	}
	return [[self deviceName] isEqualToString:@"iPhone4"] || [[self deviceName] isEqualToString:@"iPhone 4S"];
}

- (BOOL) isIphone5 {
	if([self isSimulator]) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		if(bounds.size.width == 640 && bounds.size.height == 1136) {
			return TRUE;
		}
		if(bounds.size.width == 320 && bounds.size.height == 568) {
			return TRUE;
		}
	}
	return [[self deviceName] isEqualToString:@"iPhone5"] || [[self deviceName] isEqualToString:@"iPhone 5s"] || [[self deviceName] isEqualToString:@"iPhone 5c"];
}

- (BOOL) is32AspectRatio {
	NSArray * devices = @[@"iPod Touch",@"iPhone",@"iPhone 4",@"iPhone 4S"];
	
	if([devices indexOfObject:[self deviceName]] != NSNotFound) {
		return TRUE;
	}
	
	if([self isSimulator]) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		if(bounds.size.width == 320 && bounds.size.height == 480) {
			return TRUE;
		}
	}
	
	return FALSE;
}

- (BOOL) is169AspectRatio {
	NSArray * devices = @[@"iPhone 5",@"iPhone 5S",@"iPhone 5c",@"iPhone 6",@"iPhone 6 Plus"];
	
	if([devices indexOfObject:[self deviceName]] != NSNotFound) {
		return TRUE;
	}
	
	if([self isSimulator]) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		if(bounds.size.width == 640 && bounds.size.height == 960) {
			return TRUE;
		}
		if(bounds.size.width == 750 && bounds.size.height == 1334) {
			return TRUE;
		}
		if(bounds.size.width == 1080 && bounds.size.height == 1920) {
			return TRUE;
		}
	}
	
	return FALSE;
}

- (BOOL) is43AspectRatio {
	NSArray * devices = @[@"iPad", @"iPad 2",@"iPad Mini",@"iPad Air"];
	
	if([devices indexOfObject:[self deviceName]] != NSNotFound) {
		return TRUE;
	}
	
	if([self isSimulator]) {
		CGRect bounds = [UIScreen mainScreen].bounds;
		if(bounds.size.width == 768 && bounds.size.height == 1024) {
			return TRUE;
		}
		if(bounds.size.width == 1536 && bounds.size.height == 2048) {
			return TRUE;
		}
	}
	
	return FALSE;
}

@end
