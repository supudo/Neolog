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

@synthesize nests, headerNests, headerLetters, webService, navTitle;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = NSLocalizedString(@"Choose", @"Choose");
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OrderPos" ascending:YES];
	NSArray *arrSorters = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[sortDescriptor release];
	nests = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"Nest" sortDescriptors:arrSorters]];
	[arrSorters release];
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
		return [[nlSettings sharednlSettings].letters count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellIdentifier] autorelease];
		cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
		cell.selectionStyle = UITableViewCellSelectionStyleBlue;
		cell.textLabel.font = [UIFont fontWithName:@"Verdana-Bold" size:18.0];
	}
	if (indexPath.section == 0)
		cell.textLabel.text = ((dbNest *)[nests objectAtIndex:indexPath.row]).Title;
	else {
		if (indexPath.row >= [[nlSettings sharednlSettings].letters count])
			cell.textLabel.text = @"др.";
		else
			cell.textLabel.text = [[nlSettings sharednlSettings].letters objectAtIndex:indexPath.row];
	}
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if (indexPath.section == 0) {
		navTitle = ((dbNest *)[nests objectAtIndex:indexPath.row]).Title;
		[webService fetchWordsForNest:[((dbNest *)[nests objectAtIndex:indexPath.row]).ID intValue]];
	}
	else {
		if (indexPath.row >= [[nlSettings sharednlSettings].letters count]) {
			navTitle = @"X";
			[webService fetchWordsForLetter:@"X"];
		}
		else {
			navTitle = [[nlSettings sharednlSettings].letters objectAtIndex:indexPath.row];
			[webService fetchWordsForLetter:[[nlSettings sharednlSettings].letters objectAtIndex:indexPath.row]];
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
		[lblTitle setText:NSLocalizedString(@"Nests", @"Nests")];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor whiteColor]];
		[lblTitle setFont:[UIFont fontWithName:@"Verdana-Bold" size:22.0]];
		[lblTitle setFrame:CGRectMake(10, 0, 300, 50)];
		[headerNests addSubview:lblTitle];
		[lblTitle release];
	}
	if (headerLetters == nil) {
		headerLetters  = [[UIView alloc] init];
		UILabel *lblTitle = [[UILabel alloc] init];
		[lblTitle setText:NSLocalizedString(@"Letters", @"Letters")];
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor whiteColor]];
		[lblTitle setFont:[UIFont fontWithName:@"Verdana-Bold" size:22.0]];
		[lblTitle setFrame:CGRectMake(10, 0, 300, 50)];
		[headerLetters addSubview:lblTitle];
		[lblTitle release];
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
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:NSLocalizedString(@"NONO", @"NONO") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
	[alert show];
	[alert release];
}

- (void)fetchWordsForNestFinished:(id)sender {
	Words *tvc = [[Words alloc] initWithNibName:@"Words" bundle:nil];
	tvc.navTitle = navTitle;
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

- (void)fetchWordsForLetterFinished:(id)sender {
	Words *tvc = [[Words alloc] initWithNibName:@"Words" bundle:nil];
	tvc.navTitle = navTitle;
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

#pragma mark -
#pragma mark Memory management

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	nests = nil;
	[nests release];
	headerNests = nil;
	[headerNests release];
	headerLetters = nil;
	[headerLetters release];
	webService = nil;
	[webService release];
	navTitle = nil;
	[navTitle release];
    [super viewDidUnload];
}

- (void)dealloc {
	[nests release];
	[headerNests release];
	[headerLetters release];
	[webService release];
	[navTitle release];
    [super dealloc];
}

@end
