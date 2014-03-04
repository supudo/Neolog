//
//  WordComments.m
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "WordComments.h"
#import "CellWordComment.h"
#import "DBManagedObjectContext.h"
#import "WordSendComment.h"

static NSString *kCellIdentifier = @"identifComments";

@implementation WordComments

@synthesize fetchedResultsController, cellComment, entComment;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = [nlSettings sharedInstance].currentDbWord.Word;

	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addComment)];

	NSIndexPath *tableSelection = [self.tableView indexPathForSelectedRow];
	[self.tableView deselectRowAtIndexPath:tableSelection animated:NO];
	
	NSError *error = nil;
	if (![[self fetchedResultsController] performFetch:&error]) {
		[[nlSettings sharedInstance] LogThis: [NSString stringWithFormat:@"Unresolved error %@, %@", error, [error userInfo]]];
		abort();
	}
	[self.tableView reloadData];
}

- (void)addComment {
	WordSendComment *tvc = [[WordSendComment alloc] initWithNibName:@"WordSendComment" bundle:nil];
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
	CellWordComment *cell = (CellWordComment *)[tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CellWordComment" owner:self options:nil];
		cell = cellComment;
		cell.accessoryType = UITableViewCellAccessoryNone;
		self.cellComment = nil;
	}
	[cell setComment:((dbWordComment *)[fetchedResultsController objectAtIndexPath:indexPath]).Comment];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	WordSendComment *tvc = [[WordSendComment alloc] initWithNibName:@"WordSendComment" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	CellWordComment *cell = (CellWordComment *)[self.tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		[[NSBundle mainBundle] loadNibNamed:@"CellWordComment" owner:self options:nil];
		cell = cellComment;
		self.cellComment = nil;
	}
	[cell setComment:((dbWordComment *)[fetchedResultsController objectAtIndexPath:indexPath]).Comment];
	return cell.frame.size.height;
}

- (NSFetchedResultsController *)fetchedResultsController {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	
    if (fetchedResultsController == nil) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
		
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"WordComment" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
        [fetchRequest setEntity:entity];
        
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"CommentID" ascending:YES];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
        
        [fetchRequest setSortDescriptors:sortDescriptors];
		
        NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[dbManagedObjectContext managedObjectContext] sectionNameKeyPath:nil cacheName:nil];
        aFetchedResultsController.delegate = self;
        self.fetchedResultsController = aFetchedResultsController;
        
    }
	return fetchedResultsController;
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	fetchedResultsController = nil;
	cellComment = nil;
	[super viewDidUnload];
}


@end

