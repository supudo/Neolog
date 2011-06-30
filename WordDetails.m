//
//  WordDetails.m
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "WordDetails.h"
#import "WordComments.h"
#import <QuartzCore/QuartzCore.h>

@implementation WordDetails

@synthesize lblWord, lblAuthor, lblURL, lblLExample, lblLEthimology;
@synthesize txtDescription, txtExample, txtEthimology;
@synthesize contentView, scrollView;
@synthesize btnComments;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = [nlSettings sharednlSettings].currentDbWord.Word;
	self.lblLExample.text = NSLocalizedString(@"Example", @"Example");
	self.lblLEthimology.text = NSLocalizedString(@"Ethimology", @"Ethimology");
	[self.btnComments setTitle:NSLocalizedString(@"SeeComments", @"SeeComments") forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	scrollView.contentSize = CGSizeMake(320, 691);

	lblWord.text = [nlSettings sharednlSettings].currentDbWord.Word;
	lblAuthor.text = [nlSettings sharednlSettings].currentDbWord.AddedBy;

	NSString *authorURL = @"";
	if ([nlSettings sharednlSettings].currentDbWord.AddedByURL != nil)
		authorURL = [nlSettings sharednlSettings].currentDbWord.AddedByURL;
	if (![[nlSettings sharednlSettings].currentDbWord.AddedByEmail isEqualToString:@""] && [nlSettings sharednlSettings].currentDbWord.AddedByEmail != nil) {
		if ([authorURL isEqualToString:@""])
			authorURL = [nlSettings sharednlSettings].currentDbWord.AddedByEmail;
		else
			authorURL = [NSString stringWithFormat:@"%@ // %@", authorURL, [nlSettings sharednlSettings].currentDbWord.AddedByEmail];
	}
	lblURL.text = authorURL;

	txtDescription.hidden = NO;
	txtDescription.text = [nlSettings sharednlSettings].currentDbWord.Description;
	txtDescription.font = [UIFont fontWithName:@"Verdana" size:14];
	txtDescription.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtDescription.layer.cornerRadius = 5;
	txtDescription.clipsToBounds = YES;
	
	txtExample.hidden = NO;
	lblLExample.hidden = NO;
	txtExample.text = [nlSettings sharednlSettings].currentDbWord.Example;
	txtExample.font = [UIFont fontWithName:@"Verdana" size:14];
	txtExample.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtExample.layer.cornerRadius = 5;
	txtExample.clipsToBounds = YES;
	if ([nlSettings sharednlSettings].currentDbWord.Example == nil || [[nlSettings sharednlSettings].currentDbWord.Example isEqualToString:@""]) {
		txtExample.hidden = YES;
		lblLExample.hidden = YES;
	}
	
	txtEthimology.hidden = NO;
	lblLEthimology.hidden = NO;
	txtEthimology.text = [nlSettings sharednlSettings].currentDbWord.Ethimology;
	txtEthimology.font = [UIFont fontWithName:@"Verdana" size:14];
	txtEthimology.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtEthimology.layer.cornerRadius = 5;
	txtEthimology.clipsToBounds = YES;
	if ([nlSettings sharednlSettings].currentDbWord.Ethimology == nil || [[nlSettings sharednlSettings].currentDbWord.Ethimology isEqualToString:@""]) {
		txtEthimology.hidden = YES;
		lblLEthimology.hidden = YES;
		CGRect frameTemp = lblLEthimology.frame;
		frameTemp.size.height = 0;
		lblLEthimology.frame = frameTemp;
		frameTemp = txtEthimology.frame;
		frameTemp.size.height = 0;
		txtEthimology.frame = frameTemp;
	}

	[self doDesign];
}

- (void)doDesign {
	CGRect frameTemp;
	CGSize c;

	// Description text
	c = txtDescription.contentSize;
	frameTemp = txtDescription.frame;
	frameTemp.size.height = c.height;
	txtDescription.frame = frameTemp;
	
	// Example label
	frameTemp = lblLExample.frame;
	frameTemp.origin.y = txtDescription.frame.origin.y + txtDescription.frame.size.height + 10;
	lblLExample.frame = frameTemp;
	
	// Example text
	c = txtExample.contentSize;
	frameTemp = txtExample.frame;
	frameTemp.size.height = c.height;
	frameTemp.origin.y = lblLExample.frame.origin.y + lblLExample.frame.size.height + 10;
	txtExample.frame = frameTemp;
	
	// Ethimology label
	frameTemp = lblLEthimology.frame;
	frameTemp.origin.y = txtExample.frame.origin.y + txtExample.frame.size.height + ((frameTemp.size.height > 1) ? 10 : 0);
	lblLEthimology.frame = frameTemp;
	
	// Ethimology text
	c = txtEthimology.contentSize;
	frameTemp = txtEthimology.frame;
	frameTemp.size.height = c.height;
	frameTemp.origin.y = lblLEthimology.frame.origin.y + lblLEthimology.frame.size.height + ((frameTemp.size.height > 1) ? 10 : 0);
	txtEthimology.frame = frameTemp;
	
	// Author label
	frameTemp = lblAuthor.frame;
	frameTemp.origin.y = txtEthimology.frame.origin.y + txtEthimology.frame.size.height + 10;
	lblAuthor.frame = frameTemp;
	
	// URL label
	frameTemp = lblURL.frame;
	frameTemp.origin.y = lblAuthor.frame.origin.y + lblAuthor.frame.size.height + 10;
	lblURL.frame = frameTemp;
	
	// Button
	frameTemp = btnComments.frame;
	frameTemp.origin.y = lblURL.frame.origin.y + lblURL.frame.size.height + 10;
	btnComments.frame = frameTemp;
	
	// Content view
	frameTemp = contentView.frame;
	frameTemp.size.height = btnComments.frame.origin.y + btnComments.frame.size.height + 10;
	contentView.frame = frameTemp;

	// Scroll view
	frameTemp = scrollView.frame;
	scrollView.contentSize = CGSizeMake(contentView.frame.size.width, contentView.frame.size.height);
	scrollView.frame = frameTemp;

	// self
	frameTemp = self.view.frame;
	frameTemp.size.height = scrollView.frame.size.height;
	self.view.frame = frameTemp;
}

- (IBAction) iboComments:(id)sender {
	WordComments *tvc = [[WordComments alloc] initWithNibName:@"WordComments" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
	[tvc release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	lblWord = nil;
	[lblWord release];
	lblAuthor = nil;
	[lblAuthor release];
	lblURL = nil;
	[lblURL release];
	lblLExample = nil;
	[lblLExample release];
	lblLEthimology = nil;
	[lblLEthimology release];
	txtDescription = nil;
	[txtDescription release];
	txtExample = nil;
	[txtExample release];
	txtEthimology = nil;
	[txtEthimology release];
	contentView = nil;
	[contentView release];
	scrollView = nil;
	[scrollView release];
	btnComments = nil;
	[btnComments release];
    [super viewDidUnload];
}

- (void)dealloc {
	[lblWord release];
	[lblAuthor release];
	[lblURL release];
	[lblLExample release];
	[lblLEthimology release];
	[txtDescription release];
	[txtExample release];
	[txtEthimology release];
	[contentView release];
	[scrollView release];
	[btnComments release];
    [super dealloc];
}

@end
