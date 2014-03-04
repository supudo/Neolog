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
	self.navigationItem.title = [nlSettings sharedInstance].currentDbWord.Word;
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendComment)];
	txtAuthor.text = [nlSettings sharedInstance].currentWord.name;
	if (webService == nil)
		webService = [[WebService alloc] init];
	[webService setDelegate:self];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (void)sendComment {
	[webService sendComment:[[nlSettings sharedInstance].currentDbWord.WordID intValue] author:txtAuthor.text comment:txtComment.text];
}

- (void)serviceError:(id)sender error:(NSString *)errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@.", LocalizedString(@"Error", @"Error")] delegate:self cancelButtonTitle:LocalizedString(@"NONO", @"NONO") otherButtonTitles:LocalizedString(@"OK", @"OK"), nil];
	[alert show];
}
	 
- (void)sendCommentFinished:(id)sender {
	[webService fetchWordComments:[[nlSettings sharedInstance].currentDbWord.WordID intValue]];
}

- (void)fetchWordCommentsFinished:(id)sender {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:LocalizedString(@"Bravo", @"Bravo") delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles:nil];
	[alert show];
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	[[self navigationController] popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	txtAuthor = nil;
	txtComment = nil;
	webService = nil;
    [super viewDidUnload];
}


@end
