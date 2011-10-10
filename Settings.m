//
//  Settings.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "Settings.h"
#import "DBManagedObjectContext.h"
#import "dbSetting.h"
#import "About.h"

@implementation Settings

@synthesize swPrivateData, lblPrivateData;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Settings", @"Settings");
	self.lblPrivateData.text = NSLocalizedString(@"RememberPrivateData", @"RememberPrivateData");
	[swPrivateData setOn:[nlSettings sharednlSettings].rememberPrivateData];
}

- (IBAction) iboPriveData:(id)sender {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSetting *entPD = (dbSetting *)[dbManagedObjectContext getEntity:@"Setting" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"StorePrivateData"]];
	[entPD setSValue:(([swPrivateData isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"Error while saving the account info: %@", [error userInfo]]];
		abort();
	}
}

- (IBAction) iboAbout:(id)sender {
	About *tvc = [[About alloc] initWithNibName:@"About" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [nlSettings sharednlSettings].shouldRotate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	swPrivateData = nil;
	[swPrivateData release];
	lblPrivateData = nil;
	[lblPrivateData release];
    [super viewDidUnload];
}

- (void)dealloc {
	[swPrivateData release];
	[lblPrivateData release];
    [super dealloc];
}

@end
