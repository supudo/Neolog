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
#import "BlackAlertView.h"
#import <Twitter/Twitter.h>

@implementation WordDetails

@synthesize lblWord, lblAuthor, lblURL, lblLExample, lblLEthimology;
@synthesize txtDescription, txtExample, txtEthimology;
@synthesize contentView, scrollView;
@synthesize btnComments;

- (void)viewDidLoad {
	[super viewDidLoad];
	self.navigationItem.title = [nlSettings sharedInstance].currentDbWord.Word;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.lblLExample.text = LocalizedString(@"Example", @"Example");
	self.lblLEthimology.text = LocalizedString(@"Ethimology", @"Ethimology");
	[self.btnComments setTitle:LocalizedString(@"SeeComments", @"SeeComments") forState:UIControlStateNormal];

	scrollView.contentSize = CGSizeMake(320, 691);

	lblWord.text = [nlSettings sharedInstance].currentDbWord.Word;
    NSString *ad = [nlSettings sharedInstance].currentDbWord.AddedBy;
    if ([nlSettings sharedInstance].currentDbWord.AddedAtDate != nil) {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"dd/MM/yyyy"];
        ad = [NSString stringWithFormat:@"%@ @ %@", ad, [df stringFromDate:[nlSettings sharedInstance].currentDbWord.AddedAtDate]];
    }
	lblAuthor.text = ad;

	NSString *authorURL = @"";
	if ([nlSettings sharedInstance].currentDbWord.AddedByURL != nil)
		authorURL = [nlSettings sharedInstance].currentDbWord.AddedByURL;
	if (![[nlSettings sharedInstance].currentDbWord.AddedByEmail isEqualToString:@""] && [nlSettings sharedInstance].currentDbWord.AddedByEmail != nil) {
		if ([authorURL isEqualToString:@""])
			authorURL = [nlSettings sharedInstance].currentDbWord.AddedByEmail;
		else
			authorURL = [NSString stringWithFormat:@"%@ // %@", authorURL, [nlSettings sharedInstance].currentDbWord.AddedByEmail];
	}
	lblURL.text = authorURL;

	txtDescription.hidden = NO;
	txtDescription.text = [nlSettings sharedInstance].currentDbWord.Description;
	txtDescription.font = [UIFont fontWithName:@"Verdana" size:14];
	txtDescription.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtDescription.layer.cornerRadius = 2;
	txtDescription.clipsToBounds = YES;
	
	txtExample.hidden = NO;
	lblLExample.hidden = NO;
	txtExample.text = [nlSettings sharedInstance].currentDbWord.Example;
	txtExample.font = [UIFont fontWithName:@"Verdana" size:14];
	txtExample.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtExample.layer.cornerRadius = 2;
	txtExample.clipsToBounds = YES;
	if ([nlSettings sharedInstance].currentDbWord.Example == nil || [[nlSettings sharedInstance].currentDbWord.Example isEqualToString:@""]) {
		txtExample.hidden = YES;
		lblLExample.hidden = YES;
	}
	
	txtEthimology.hidden = NO;
	lblLEthimology.hidden = NO;
	txtEthimology.text = [nlSettings sharedInstance].currentDbWord.Ethimology;
	txtEthimology.font = [UIFont fontWithName:@"Verdana" size:14];
	txtEthimology.contentInset = UIEdgeInsetsMake(-4, -4, 0, 0);
	txtEthimology.layer.cornerRadius = 5;
	txtEthimology.clipsToBounds = NO;
	if ([nlSettings sharedInstance].currentDbWord.Ethimology == nil || [[nlSettings sharedInstance].currentDbWord.Ethimology isEqualToString:@""]) {
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
    [txtDescription sizeToFit];
    [txtDescription setBackgroundColor:[UIColor clearColor]];
    [txtDescription setTextColor:[UIColor whiteColor]];
	
	// Example label
	frameTemp = lblLExample.frame;
	frameTemp.origin.y = txtDescription.frame.origin.y + txtDescription.frame.size.height + 10;
	lblLExample.frame = frameTemp;
    [lblLExample sizeToFit];
	
	// Example text
	c = txtExample.contentSize;
	frameTemp = txtExample.frame;
	frameTemp.size.height = c.height;
	frameTemp.origin.y = lblLExample.frame.origin.y + lblLExample.frame.size.height + 10;
	txtExample.frame = frameTemp;
    [txtExample sizeToFit];
    [txtExample setBackgroundColor:[UIColor clearColor]];
    [txtExample setTextColor:[UIColor whiteColor]];
	
	// Ethimology label
	frameTemp = lblLEthimology.frame;
	frameTemp.origin.y = txtExample.frame.origin.y + txtExample.frame.size.height + ((frameTemp.size.height > 1) ? 10 : 0);
	lblLEthimology.frame = frameTemp;
    [lblLEthimology sizeToFit];
	
	// Ethimology text
	c = txtEthimology.contentSize;
	frameTemp = txtEthimology.frame;
	frameTemp.size.height = c.height;
	frameTemp.origin.y = lblLEthimology.frame.origin.y + lblLEthimology.frame.size.height + ((frameTemp.size.height > 1) ? 10 : 0);
	txtEthimology.frame = frameTemp;
    [txtEthimology sizeToFit];
    [txtEthimology setBackgroundColor:[UIColor clearColor]];
    [txtEthimology setTextColor:[UIColor whiteColor]];
	
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
}

#pragma mark -
#pragma mark Twitter

- (IBAction)sendTwitter:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) {
        NSMutableString *twitterMessage = [[NSMutableString alloc] init];
        [twitterMessage setString:@"Neolog.bg - "];
        [twitterMessage appendFormat:@"%@ : ", [nlSettings sharedInstance].currentDbWord.Word];
        [twitterMessage appendFormat:@"http://www.neolog.bg/word/%i", [[nlSettings sharedInstance].currentDbWord.WordID intValue]];
        [twitterMessage appendFormat:@" #neologbg"];
        
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:twitterMessage];
        [self presentViewController:tweetSheet animated:YES completion:nil];
    }
    else {
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:LocalizedString(@"TwitterNoAccount", @"TwitterNoAccount") delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
}

#pragma mark -
#pragma mark Facebook

- (IBAction)sendFacebook:(id)sender {
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        NSMutableString *facebookMessage = [[NSMutableString alloc] init];
        [facebookMessage setString:@"Neolog.bg\n"];
        [facebookMessage appendFormat:@"%@\n", [nlSettings sharedInstance].currentDbWord.Word];
        [facebookMessage appendFormat:@"http://www.neolog.bg/word/%i\n", [[nlSettings sharedInstance].currentDbWord.WordID intValue]];
        [facebookMessage appendFormat:@"%@", [nlSettings sharedInstance].currentDbWord.Description];
        SLComposeViewController *controller = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [controller setInitialText:facebookMessage];
        [self presentViewController:controller animated:YES completion:Nil];
    }
    else {
        [BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
        //BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"SocNet.Message.Facebook.Error", @"SocNet.Message.Twitter.Error") delegate:self cancelButtonTitle:NSLocalizedString(@"UI.OK", @"UI.OK") otherButtonTitles:nil];
        BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:LocalizedString(@"FacebookNoAccount", @"FacebookNoAccount") delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles:nil];
        alert.tag = 0;
        [alert show];
    }
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	lblWord = nil;
	lblAuthor = nil;
	lblURL = nil;
	lblLExample = nil;
	lblLEthimology = nil;
	txtDescription = nil;
	txtExample = nil;
	txtEthimology = nil;
	contentView = nil;
	scrollView = nil;
	btnComments = nil;
    [super viewDidUnload];
}


@end
