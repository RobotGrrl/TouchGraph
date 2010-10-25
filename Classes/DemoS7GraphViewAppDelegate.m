//
//  DemoS7GraphViewAppDelegate.m
//  DemoS7GraphView
//
//  Created by Rudi Farkas on 20.12.09.
//  Copyright Wolfscliff 2009. All rights reserved.
//

#import "DemoS7GraphViewAppDelegate.h"
#import "RootViewController.h"


@implementation DemoS7GraphViewAppDelegate

@synthesize window;
@synthesize rootViewController;


#pragma mark -
#pragma mark Application lifecycle

- (void)applicationDidFinishLaunching:(UIApplication *)application {    
    
	// Create main window programmatically 
	
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

	// Create and configure the view controller
	
	rootViewController = [[RootViewController alloc] init];
			
	[window addSubview:[rootViewController view]];
    [window makeKeyAndVisible];
}


- (void)applicationWillTerminate:(UIApplication *)application {
	// Save data if appropriate
}


#pragma mark -
#pragma mark Memory management

- (void)dealloc {
	[rootViewController release];
	[window release];
	[super dealloc];
}


@end

