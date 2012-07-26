//
//  SerendipitorAppDelegate.m
//  Serendipitor
//
//  Created by David Jonas Castanheira on 7/14/10.
//  Copyright __MyCompanyName__ 2010. All rights reserved.
//

#import "SerendipitorAppDelegate.h"
#import "SerendipitorViewController.h"

@implementation SerendipitorAppDelegate

@synthesize window;
@synthesize viewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    
    // Override point for customization after app launch
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [window addSubview:viewController.view];
    [window makeKeyAndVisible];
	
	return YES;
}


- (void)applicationWillTerminate:(UIApplication *)application
{
	NSFileManager *fm = [NSFileManager defaultManager];
	NSString *directory = [self applicationDocumentsDirectory];
	NSError *error = nil;
	for (NSString *file in [fm contentsOfDirectoryAtPath:directory error:&error]) {
		BOOL success = [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@", directory, file] error:&error];
		if (!success || error) {
			NSLog(@"ERROR DELETING FILE USER INFO: %@", [error userInfo]);
			NSLog(@"ERROR DELETING FILE LOCALIZED DESCRIPTION: %@", [error localizedDescription]);
			NSLog(@"ERROR DELETING FILE LOCALIZED FAILURE REASON: %@", [error localizedFailureReason]);
		}
		else {
			NSLog(@"Deleted file: %@", file);
		}
		
	}
}

- (NSString *)applicationDocumentsDirectory {	
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)dealloc {
    [viewController release];
    [window release];
    [super dealloc];
}


@end
