//
//  Words.m
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "Words.h"
#import "BlackAlertView.h"
#import "DBManagedObjectContext.h"
#import "WordDetails.h"

static NSString *kCellIdentifier = @"identifWords";

@implementation Words

@synthesize navTitle, webService, fetchedResultsController, entWord;

#pragma mark -
#pragma mark View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
	self.navigationItem.title = navTitle;

	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];

	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];

	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[[nlSettings sharednlSettings] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return [nlSettings sharednlSettings].shouldRotate;
}

#pragma mark -
#pragma mark WebService delegates

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:NSLocalizedString(@"NONO", @"NONO") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
	[alert show];
	[alert release];
}

- (void)fetchWordCommentsFinished:(id)sender {
	WordDetails *tvc = [[WordDetails alloc] initWithNibName:@"WordDetails" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

#pragma mark -
#pragma mark Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
	}
	cell.textLabel.text = ((dbWord *)[fetchedResultsController objectAtIndexPath:indexPath]).Word;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	entWord = (dbWord *)[fetchedResultsController objectAtIndexPath:indexPath];
	[nlSettings sharednlSettings].currentDbWord = entWord;
	[webService fetchWordComments:[entWord.WordID intValue]];
}

- (NSFetchedResultsController *)fetchedResultsController {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Word" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Word" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];

        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
        [aFetchedResultsController release];
        [fetchRequest release];
        [sortDescriptor release];
        [sortDescriptors release];
    }
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Misc

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[self navigationController] popViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	navTitle = nil;
	[navTitle release];
	webService = nil;
	[webService release];
	fetchedResultsController = nil;
	[fetchedResultsController release];
	entWord = nil;
	[entWord release];
	[super viewDidUnload];
}

- (void)dealloc {
	[navTitle release];
	//[webService release];
	[fetchedResultsController release];
	//[entWord release];
    [super dealloc];
}

@end

