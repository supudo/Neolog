//
//  WordDesc.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "WordDesc.h"

@implementation WordDesc

@synthesize txtDesc, descID;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if (self.descID == 1) {
		self.navigationItem.title = NSLocalizedString(@"Description", @"Description");
		txtDesc.text = [nlSettings sharednlSettings].currentWord.meaning;
	}
	else if (self.descID == 2) {
		self.navigationItem.title = NSLocalizedString(@"Example", @"Example");
		txtDesc.text = [nlSettings sharednlSettings].currentWord.example;
	}
	else if (self.descID == 3) {
		self.navigationItem.title = NSLocalizedString(@"Ethimology", @"Ethimology");
		txtDesc.text = [nlSettings sharednlSettings].currentWord.ethimology;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[txtDesc resignFirstResponder];
	if (self.descID == 1)
		[nlSettings sharednlSettings].currentWord.meaning = txtDesc.text;
	else if (self.descID == 2)
		[nlSettings sharednlSettings].currentWord.example = txtDesc.text;
	else if (self.descID == 3)
		[nlSettings sharednlSettings].currentWord.ethimology = txtDesc.text;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return [nlSettings sharednlSettings].shouldRotate;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	txtDesc = nil;
	[txtDesc release];
    [super viewDidUnload];
}

- (void)dealloc {
	[txtDesc release];
    [super dealloc];
}

@end
