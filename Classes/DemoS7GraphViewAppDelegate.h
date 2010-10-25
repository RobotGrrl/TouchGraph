//
//  DemoS7GraphViewAppDelegate.h
//  DemoS7GraphView
//
//  Created by Rudi Farkas on 20.12.09.
//  Copyright Wolfscliff 2009. All rights reserved.
//

@interface DemoS7GraphViewAppDelegate : NSObject <UIApplicationDelegate> {
    
    UIWindow *window;
    UIViewController *rootViewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UIViewController *rootViewController;

@end

