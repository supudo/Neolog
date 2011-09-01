//
//  WordSendComment.m
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "WordSendComment.h"
#import "BlackAlertView.h"

@implementation WordSendComment

@synthesize txtAuthor, txtComment, webService;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = [nlSettings sharednlSettings].currentDbWord.Word;
	self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendComment)] autorelease];
	txtAuthor.text = [nlSettings sharednlSettings].currentWord.name;
	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)sendComment {
	[webService sendComment:[[nlSettings sharednlSettings].currentDbWord.WordID intValue] author:txtAuthor.text comment:txtComment.text];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", NSLocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:NSLocalizedString(@"NONO", @"NONO") otherButtonTitles:NSLocalizedString(@"OK", @"OK"), nil];
	[alert show];
	[alert release];
}
	 
- (void)sendCommentFinished:(id)sender {
	[webService fetchWordComments:[[nlSettings sharednlSettings].currentDbWord.WordID intValue]];
}

- (void)fetchWordCommentsFinished:(id)sender {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Bravo", @"Bravo") delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	[alert show];
	[alert release];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	txtAuthor = nil;
	[txtAuthor release];
	txtComment = nil;
	[txtComment release];
	webService = nil;
	[webService release];
    [super viewDidUnload];
}

- (void)dealloc {
	[txtAuthor release];
	[txtComment release];
	[webService release];
    [super dealloc];
}

@end
