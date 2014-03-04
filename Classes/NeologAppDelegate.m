//
//  NeologAppDelegate.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "NeologAppDelegate.h"
#import "Loading.h"

NeologAppDelegate *appDelegate;

@implementation NeologAppDelegate

@synthesize window;
@synthesize tabBarController;
@synthesize loadingView;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	appDelegate = self;
	[self.window addSubview:self.loadingView.view];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
}


@end

