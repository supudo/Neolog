//
//  LettersAndNests.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "LettersAndNests.h"
#import "Words.h"
#import "DBManagedObjectContext.h"
#import "dbNest.h"
#import "BlackAlertView.h"

static NSString *kCellIdentifier = @"identifLettersAndNests";

@implementation LettersAndNests

@synthesize nests, headerNests, headerLetters, webService, navTitle, searchActive;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(toggleSearch)];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = LocalizedString(@"Choose", @"Choose");

	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];
	
	searchActive = FALSE;
	[self toggleSearch];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OrderPos" ascending:YES];
	NSArray *arrSorters = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	nests = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"Nest" sortDescriptors:arrSorters]];
    
    self.headerNests = nil;
    self.headerLetters = nil;
    [self.tableView reloadData];
}

- (void)toggleSearch {
	if (searchActive) {
		[self.searchDisplayController.searchBar removeFromSuperview];
		searchActive = FALSE;
		CGRect f = self.view.frame;
		f.origin.y -= self.searchDisplayController.searchBar.frame.size.height;
		f.size.height += self.searchDisplayController.searchBar.frame.size.height;
		self.view.frame = f;
	}
	else {
		self.searchDisplayController.searchBar.alpha = 0;
		[self.view addSubview:self.searchDisplayController.searchBar];
		[UIView setAnimationDelegate:self];
		//[UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
		[UIView beginAnimations:nil context:nil];
		[UIView setAnimationDelay:.2];
		[UIView setAnimationDuration:.4];
		self.searchDisplayController.searchBar.alpha = 1;
		[UIView commitAnimations];
		searchActive = TRUE;
		CGRect f = self.view.frame;
		f.origin.y += self.searchDisplayController.searchBar.frame.size.height;
		f.size.height += self.searchDisplayController.searchBar.frame.size.height;
		self.view.frame = f;
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
}

#pragma mark -
#pragma mark Table delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0)
		return [nests count];
	else
		return [[nlSettings sharedInstance].letters count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18.0];
	}
	if (indexPath.section == 0)
		cell.textLabel.text = ((dbNest *)[nests objectAtIndex:indexPath.row]).Title;
	else {
		if (indexPath.row >= [[nlSettings sharedInstance].letters count])
			cell.textLabel.text = LocalizedString(@"l_dr", @"l_dr");
		else
			cell.textLabel.text = [[nlSettings sharedInstance].letters objectAtIndex:indexPath.row];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		navTitle = ((dbNest *)[nests objectAtIndex:indexPath.row]).Title;
		[webService fetchWordsForNest:[((dbNest *)[nests objectAtIndex:indexPath.row]).ID intValue]];
	}
	else {
		if (indexPath.row >= [[nlSettings sharedInstance].letters count]) {
			navTitle = @"X";
			[webService fetchWordsForLetter:@"X"];
		}
		else {
			navTitle = [[nlSettings sharedInstance].letters objectAtIndex:indexPath.row];
			[webService fetchWordsForLetter:[[nlSettings sharedInstance].letters objectAtIndex:indexPath.row]];
		}
	}
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (headerNests == nil) {
		headerNests  = [[UIView alloc] init];
		UILabel *lblTitle = [[UILabel alloc] init];
		[lblTitle setText:LocalizedString(@"Nests", @"Nests")];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor whiteColor]];
		[lblTitle setFont:[UIFont fontWithName:@"Verdana-Bold" size:22.0]];
		[lblTitle setFrame:CGRectMake(10, 0, 300, 50)];
		[headerNests addSubview:lblTitle];
	}
	if (headerLetters == nil) {
		headerLetters  = [[UIView alloc] init];
		UILabel *lblTitle = [[UILabel alloc] init];
		[lblTitle setText:LocalizedString(@"Letters", @"Letters")];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor whiteColor]];
		[lblTitle setFont:[UIFont fontWithName:@"Verdana-Bold" size:22.0]];
		[lblTitle setFrame:CGRectMake(10, 0, 300, 50)];
		[headerLetters addSubview:lblTitle];
	}
	if (section == 0)
		return headerNests;
	else
		return headerLetters;
}

#pragma mark -
#pragma mark WebService delegates

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", LocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:LocalizedString(@"NONO", @"NONO") otherButtonTitles:LocalizedString(@"OK", @"OK"), nil];
	alert.tag = 1;
	[alert show];
}

- (void)fetchWordsForNestFinished:(id)sender {
	Words *tvc = [[Words alloc] initWithNibName:@"Words" bundle:nil];
	tvc.navTitle = navTitle;
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (void)fetchWordsForLetterFinished:(id)sender {
	Words *tvc = [[Words alloc] initWithNibName:@"Words" bundle:nil];
	tvc.navTitle = navTitle;
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (void)searchForWordsFinished:(id)sender {
	Words *tvc = [[Words alloc] initWithNibName:@"Words" bundle:nil];
	tvc.navTitle = LocalizedString(@"Search", @"Search");
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (void)searchForWordsNoResultsFinished:(id)sender {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", LocalizedString(@"SearchNoResults", @"SearchNoResults")] delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	alert.tag = 3;
	[alert show];
}

#pragma mark -
#pragma mark Search delegates

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
	return NO;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
	return NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
	if ([[self.searchDisplayController searchBar].text length] <= 2) {
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", LocalizedString(@"SearchTooSmall", @"SearchTooSmall")] delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles:nil];
		alert.tag = 2;
		[alert show];
	}
	else
		[webService searchForWords:[self.searchDisplayController searchBar].text];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	nests = nil;
	headerNests = nil;
	headerLetters = nil;
	webService = nil;
	navTitle = nil;
    [super viewDidUnload];
}


@end
