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
		[[nlSettings sharedInstance] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

#pragma mark -
#pragma mark WebService delegates

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", LocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:LocalizedString(@"NONO", @"NONO") otherButtonTitles:LocalizedString(@"OK", @"OK"), nil];
	[alert show];
}

- (void)fetchWordCommentsFinished:(id)sender {
	WordDetails *tvc = [[WordDetails alloc] initWithNibName:@"WordDetails" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
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
    dbWord *w = ((dbWord *)[fetchedResultsController objectAtIndexPath:indexPath]);
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
		cell.detailTextLabel.font = [UIFont fontWithName:@"Verdana" size:14.0];
	}
	cell.textLabel.text = w.Word;
    cell.detailTextLabel.text = @"";
    if ([w.CommentCount intValue] > 0)
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", LocalizedString(@"CommentsCount", @"CommentsCount"), w.CommentCount];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	entWord = (dbWord *)[fetchedResultsController objectAtIndexPath:indexPath];
	[nlSettings sharedInstance].currentDbWord = entWord;
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
	webService = nil;
	fetchedResultsController = nil;
	entWord = nil;
	[super viewDidUnload];
}


@end

