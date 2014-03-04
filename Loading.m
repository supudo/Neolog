//
//  Loading.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "Loading.h"
#import "BlackAlertView.h"

@implementation Loading

@synthesize timer, webService;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"Neolog";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self performSelector:@selector(startSync) withObject:nil afterDelay:1.0];
}

- (void)startSync {
	self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(startSyncTimer) userInfo:nil repeats:NO];
}

- (void)startSyncTimer {
	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];
	[webService getNests];
}

-(void)finishSync {
	[self startTabApp];
}

- (void)serviceError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", LocalizedString(@"Error", @"Error"), errorMessage] delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles: nil];
	[alert show];
}

- (void)getNestsFinished:(id)sender {
	[self.webService getStaticContent];
}

- (void)getStaticContentFinished:(id)sender {
	[self finishSync];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self startTabApp];
}

- (void)startTabApp {
	UIView *tabBarView = [[appDelegate tabBarController] view];
	[tabBarView setCenter:CGPointMake(tabBarView.center.x, tabBarView.center.y)];
	tabBarView.alpha = 0;
	[[appDelegate tabBarController] viewWillAppear:YES];
	[appDelegate tabBarController].selectedIndex = 0;
	[self.view.superview addSubview:tabBarView];
	[UIView setAnimationDelegate:self];
	//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
	[UIView beginAnimations:nil context:nil];
	[UIView setAnimationDelay:.2];
	[UIView setAnimationDuration:.4];
	tabBarView.alpha = 1;
	[UIView commitAnimations];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	timer = nil;
	webService = nil;
    [super viewDidUnload];
}


@end
