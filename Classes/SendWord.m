//
//  SendWord.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "SendWord.h"
#import "WordDesc.h"
#import "DBManagedObjectContext.h"
#import "dbAccountData.h"
#import "dbNest.h"
#import "BlackAlertView.h"

@implementation SendWord

@synthesize scrollView, contentView;
@synthesize txtName, txtEmail, txtURL, txtWord, txtMeaning, txtExample, txtEthimology;
@synthesize nests, btnNests, nestRow, webService, btnGaz;
@synthesize lblName, lblEmail, lblURL, lblWord, lblNest, lblDescription, lblExample, lblEthimology;

- (void)viewDidLoad {
	[super viewDidLoad];
	scrollView.contentSize = CGSizeMake(320, 650);

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OrderPos" ascending:YES];
	NSArray *arrSorters = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	nests = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"Nest" sortDescriptors:arrSorters]];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self navigationController].navigationBar.topItem.title = LocalizedString(@"SendWord", @"SendWord");
	[self.btnGaz setTitle:LocalizedString(@"GO", @"GO") forState:UIControlStateNormal];

	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
		contentView.frame = CGRectMake(0, 0, 320, 650);
	else
		contentView.frame = CGRectMake(0, 0, 480, 650);

	if ([txtName.text isEqualToString:@""])
		txtName.text = [nlSettings sharedInstance].currentWord.name;
	if ([txtEmail.text isEqualToString:@""])
		txtEmail.text = [nlSettings sharedInstance].currentWord.email;
	if ([txtURL.text isEqualToString:@""])
		txtURL.text = [nlSettings sharedInstance].currentWord.url;

	txtMeaning.text = [nlSettings sharedInstance].currentWord.meaning;
	txtExample.text = [nlSettings sharedInstance].currentWord.example;
	txtEthimology.text = [nlSettings sharedInstance].currentWord.ethimology;

	if ([[nlSettings sharedInstance].currentWord.meaning length] > 15)
		txtMeaning.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharedInstance].currentWord.meaning substringToIndex:15]];
	if ([[nlSettings sharedInstance].currentWord.example length] > 15)
		txtExample.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharedInstance].currentWord.example substringToIndex:15]];
	if ([[nlSettings sharedInstance].currentWord.ethimology length] > 15)
		txtEthimology.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharedInstance].currentWord.ethimology substringToIndex:15]];

	[txtMeaning resignFirstResponder];
	[txtExample resignFirstResponder];
	[txtEthimology resignFirstResponder];
    
    lblName.text = LocalizedString(@"SWName", @"SWName");
    lblEmail.text = LocalizedString(@"SWEmail", @"SWEmail");
    lblURL.text = LocalizedString(@"SWURL", @"SWURL");
    lblWord.text = LocalizedString(@"SWWord", @"SWWord");
    lblNest.text = LocalizedString(@"SWNest", @"SWNest");
    lblDescription.text = LocalizedString(@"SWDescription", @"SWDescription");
    lblExample.text = LocalizedString(@"SWExample", @"SWExample");
    lblEthimology.text = LocalizedString(@"SWEthimology", @"SWEthimology");
    [self.btnNests setTitle:LocalizedString(@"SWNestChoose", @"SWNestChoose") forState:UIControlStateNormal];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[textField resignFirstResponder];
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
	if (textField == txtMeaning || textField == txtExample || textField == txtEthimology) {
		[textField resignFirstResponder];
		[self textFieldDidBeginEditing:textField];
		return FALSE;
	}
	else
		return TRUE;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
	if (textField == txtMeaning || textField == txtExample || textField == txtEthimology) {
		[textField resignFirstResponder];
		WordDesc *tvc = [[WordDesc alloc] initWithNibName:@"WordDesc" bundle:nil];
		if (textField == txtMeaning)
			tvc.descID = 1;
		else if (textField == txtExample)
			tvc.descID = 2;
		else if (textField == txtEthimology)
			tvc.descID = 3;
		[[self navigationController] pushViewController:tvc animated:YES];
	}
}

- (IBAction) iboNest:(id)sender {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:LocalizedString(@"Nest", @"Nest") delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") destructiveButtonTitle:LocalizedString(@"NONO", @"NONO") otherButtonTitles:nil];
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 185, 0, 0)];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	[menu addSubview:pickerView];
	[menu showFromTabBar:appDelegate.tabBarController.tabBar];
	[menu setBounds:CGRectMake(0, 0, 320, 700)];
	
	if ([nlSettings sharedInstance].currentWord.nestID > 0) {
		for (int i=0; i<[nests count]; i++) {
			if ([nlSettings sharedInstance].currentWord.nestID == [[[nests objectAtIndex:i] valueForKey:@"ID"] intValue])
				[pickerView selectRow:i inComponent:0 animated:YES];
		}
	}

}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
	return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
	return [nests count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
	return ((dbNest *)[nests objectAtIndex:row]).Title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
	nestRow = row;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == 1) {
		[btnNests setTitle:[[nests objectAtIndex:nestRow] valueForKey:@"Title"] forState:UIControlStateNormal];
		[nlSettings sharedInstance].currentWord.nestID = [[[nests objectAtIndex:nestRow] valueForKey:@"ID"] intValue];
	}
}

- (void)alertView:(UIAlertView *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (actionSheet.tag == 1) {
	}
	else if (actionSheet.tag == 2) {
	}
	else if (actionSheet.tag == 3) {
	}
}

- (IBAction) iboSend:(id)sender {
	[nlSettings sharedInstance].currentWord.name = txtName.text;
	[nlSettings sharedInstance].currentWord.email = txtEmail.text;
	[nlSettings sharedInstance].currentWord.url = txtURL.text;
	[nlSettings sharedInstance].currentWord.word = txtWord.text;
	[nlSettings sharedInstance].currentWord.meaning = txtMeaning.text;
	[nlSettings sharedInstance].currentWord.example = txtExample.text;
	[nlSettings sharedInstance].currentWord.ethimology = txtEthimology.text;

	if ([txtName.text isEqualToString:@""] ||
		[txtWord.text isEqualToString:@""] ||
		[txtMeaning.text isEqualToString:@""] ||
		[txtExample.text isEqualToString:@""]) {
		NSString *msg = LocalizedString(@"MissingReqFields", @"MissingReqFields");
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles: nil];
		alert.tag = 3;
		[alert show];
	}
	else {
		dbAccountData *ad;
		NSArray *accountData = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"AccountData" sortDescriptors:nil]];
		if ([accountData count] > 0)
			ad = (dbAccountData *)[accountData objectAtIndex:0];
		else
			ad = (dbAccountData *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountData" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
		[ad setName:[nlSettings sharedInstance].currentWord.name];
		[ad setEmail:[nlSettings sharedInstance].currentWord.email];
		[ad setURL:[nlSettings sharedInstance].currentWord.url];
		
		NSError *error = nil;
		if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
			[[nlSettings sharedInstance] LogThis:@"Error while saving the account info: %@", [error userInfo]];
			abort();
		}
		

		if (webService == nil)
			webService = [[WebService alloc] init];
		[webService setDelegate:self];
		[webService sendWord];
	}
}

- (void)sendWordFinished:(id)sender {
	txtWord.text = @"";
	txtMeaning.text = @"";
	txtExample.text = @"";
	txtEthimology.text = @"";
	if (![nlSettings sharedInstance].rememberPrivateData) {
		[nlSettings sharedInstance].currentWord.name = @"";
		[nlSettings sharedInstance].currentWord.email = @"";
		[nlSettings sharedInstance].currentWord.url = @"";
	}

	NSString *msg = LocalizedString(@"ThankYou", @"ThankYou");
	if (![nlSettings sharedInstance].currentSendWordResponse)
		msg = [NSString stringWithFormat:@"%@!", LocalizedString(@"Error", @"Error")];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles: nil];
	alert.tag = 2;
	[alert show];
}

- (void)serviceError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", LocalizedString(@"Error", @"Error"), errorMessage] delegate:self cancelButtonTitle:LocalizedString(@"OK", @"OK") otherButtonTitles: nil];
	alert.tag = 1;
	[alert show];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	scrollView = nil;
	contentView = nil;
	txtName = nil;
	txtEmail = nil;
	txtURL = nil;
	txtWord = nil;
	txtMeaning = nil;
	txtExample = nil;
	txtEthimology = nil;
	nests = nil;
	btnNests = nil;
	webService = nil;
	btnGaz = nil;
	lblName = nil;
	lblEmail = nil;
	lblURL = nil;
	lblWord = nil;
	lblNest = nil;
	lblDescription = nil;
	lblExample = nil;
	lblEthimology = nil;
    [super viewDidUnload];
}


@end
