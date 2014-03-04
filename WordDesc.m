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
		self.navigationItem.title = LocalizedString(@"Description", @"Description");
		txtDesc.text = [nlSettings sharedInstance].currentWord.meaning;
	}
	else if (self.descID == 2) {
		self.navigationItem.title = LocalizedString(@"Example", @"Example");
		txtDesc.text = [nlSettings sharedInstance].currentWord.example;
	}
	else if (self.descID == 3) {
		self.navigationItem.title = LocalizedString(@"Ethimology", @"Ethimology");
		txtDesc.text = [nlSettings sharedInstance].currentWord.ethimology;
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[txtDesc resignFirstResponder];
	if (self.descID == 1)
		[nlSettings sharedInstance].currentWord.meaning = txtDesc.text;
	else if (self.descID == 2)
		[nlSettings sharedInstance].currentWord.example = txtDesc.text;
	else if (self.descID == 3)
		[nlSettings sharedInstance].currentWord.ethimology = txtDesc.text;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	txtDesc = nil;
    [super viewDidUnload];
}


@end
