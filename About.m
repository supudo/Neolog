//
//  About.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "About.h"
#import "DBManagedObjectContext.h"
#import "dbStaticContent.h"
#import "BlackAlertView.h"

@implementation About

@synthesize webView, clickedURL, alreadyLoaded;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = @"За Neolog.bg";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	dbStaticContent *ent = (dbStaticContent *)[[DBManagedObjectContext sharedDBManagedObjectContext] getEntity:@"StaticContent" predicateString:@"ContentID = 2"];
	
	alreadyLoaded = FALSE;
	NSMutableString *txt = [[NSMutableString alloc] init];
	[txt setString:@""];
	[txt appendString:[NSString stringWithFormat:@"<html><style>html,body {font-family: Verdana; font-size: 16px; color: #ffffff; background-color: #29435E; margin: 0px; padding: 0px;} a {color: #ffffff; text-decoration: underline;} </style><body><div style=\"padding: 10px; width: 295px;\">"]];
	[txt appendString:ent.Content];
	[txt appendString:@"</div></body></html>"];
	[webView loadHTMLString:txt baseURL:nil];
	[txt release];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
	if (alreadyLoaded) {
		self.clickedURL = [request URL];
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"ExternalURLWarning", @"ExternalURLWarning") delegate:self cancelButtonTitle:NSLocalizedString(@"NONO", @"NONO") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
		[alert show];
		[alert release];
		return NO;
	}
	else {
		alreadyLoaded = TRUE;
		return YES;
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1 && self.clickedURL != nil)
		[[UIApplication sharedApplication] openURL:self.clickedURL];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	webView = nil;
	[webView release];
	clickedURL = nil;
	[clickedURL release];
    [super viewDidUnload];
}

- (void)dealloc {
	[webView release];
	[clickedURL release];
    [super dealloc];
}

@end
