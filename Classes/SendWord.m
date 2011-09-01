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
	[self navigationController].navigationBar.topItem.title = NSLocalizedString(@"SendWord", @"SendWord");
	[self.btnGaz setTitle:NSLocalizedString(@"GO", @"GO") forState:UIControlStateNormal];

	NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"OrderPos" ascending:YES];
	NSArray *arrSorters = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
	[sortDescriptor release];
	nests = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"Nest" sortDescriptors:arrSorters]];
	[arrSorters release];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	if (self.interfaceOrientation == UIInterfaceOrientationPortrait || self.interfaceOrientation == UIDeviceOrientationPortraitUpsideDown)
		contentView.frame = CGRectMake(0, 0, 320, 650);
	else
		contentView.frame = CGRectMake(0, 0, 480, 650);

	if ([txtName.text isEqualToString:@""])
		txtName.text = [nlSettings sharednlSettings].currentWord.name;
	if ([txtEmail.text isEqualToString:@""])
		txtEmail.text = [nlSettings sharednlSettings].currentWord.email;
	if ([txtURL.text isEqualToString:@""])
		txtURL.text = [nlSettings sharednlSettings].currentWord.url;

	txtMeaning.text = [nlSettings sharednlSettings].currentWord.meaning;
	txtExample.text = [nlSettings sharednlSettings].currentWord.example;
	txtEthimology.text = [nlSettings sharednlSettings].currentWord.ethimology;

	if ([[nlSettings sharednlSettings].currentWord.meaning length] > 15)
		txtMeaning.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharednlSettings].currentWord.meaning substringToIndex:15]];
	if ([[nlSettings sharednlSettings].currentWord.example length] > 15)
		txtExample.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharednlSettings].currentWord.example substringToIndex:15]];
	if ([[nlSettings sharednlSettings].currentWord.ethimology length] > 15)
		txtEthimology.text = [NSString stringWithFormat:@"%@...", [[nlSettings sharednlSettings].currentWord.ethimology substringToIndex:15]];

	[txtMeaning resignFirstResponder];
	[txtExample resignFirstResponder];
	[txtEthimology resignFirstResponder];
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
		[tvc release];
	}
}

- (IBAction) iboNest:(id)sender {
	UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:@"Гнездо" delegate:self cancelButtonTitle:@"OK" destructiveButtonTitle:@"Нене..." otherButtonTitles:nil];
	UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 185, 0, 0)];
	pickerView.delegate = self;
	pickerView.showsSelectionIndicator = YES;
	[menu addSubview:pickerView];
	[menu showFromTabBar:appDelegate.tabBarController.tabBar];
	[menu setBounds:CGRectMake(0, 0, 320, 700)];
	
	if ([nlSettings sharednlSettings].currentWord.nestID > 0) {
		for (int i=0; i<[nests count]; i++) {
			if ([nlSettings sharednlSettings].currentWord.nestID == [[[nests objectAtIndex:i] valueForKey:@"ID"] intValue])
				[pickerView selectRow:i inComponent:0 animated:YES];
		}
	}

	[pickerView release];
	[menu release];
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
		[nlSettings sharednlSettings].currentWord.nestID = [[[nests objectAtIndex:nestRow] valueForKey:@"ID"] intValue];
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
	[nlSettings sharednlSettings].currentWord.name = txtName.text;
	[nlSettings sharednlSettings].currentWord.email = txtEmail.text;
	[nlSettings sharednlSettings].currentWord.url = txtURL.text;
	[nlSettings sharednlSettings].currentWord.word = txtWord.text;
	[nlSettings sharednlSettings].currentWord.meaning = txtMeaning.text;
	[nlSettings sharednlSettings].currentWord.example = txtExample.text;
	[nlSettings sharednlSettings].currentWord.ethimology = txtEthimology.text;

	if ([txtName.text isEqualToString:@""] ||
		[txtWord.text isEqualToString:@""] ||
		[txtMeaning.text isEqualToString:@""] ||
		[txtExample.text isEqualToString:@""]) {
		NSString *msg = NSLocalizedString(@"MissingReqFields", @"MissingReqFields");
		[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
		BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
		alert.tag = 3;
		[alert show];
		[alert release];
	}
	else {
		dbAccountData *ad;
		NSArray *accountData = [[NSArray alloc] initWithArray:[[DBManagedObjectContext sharedDBManagedObjectContext] getEntities:@"AccountData" sortDescriptors:nil]];
		if ([accountData count] > 0)
			ad = (dbAccountData *)[accountData objectAtIndex:0];
		else
			ad = (dbAccountData *)[NSEntityDescription insertNewObjectForEntityForName:@"AccountData" inManagedObjectContext:[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext]];
		[ad setName:[nlSettings sharednlSettings].currentWord.name];
		[ad setEmail:[nlSettings sharednlSettings].currentWord.email];
		[ad setURL:[nlSettings sharednlSettings].currentWord.url];
		
		NSError *error = nil;
		if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
			[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"Error while saving the account info: %@", [error userInfo]]];
			abort();
		}
		
		[accountData release];

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
	if (![nlSettings sharednlSettings].rememberPrivateData) {
		[nlSettings sharednlSettings].currentWord.name = @"";
		[nlSettings sharednlSettings].currentWord.email = @"";
		[nlSettings sharednlSettings].currentWord.url = @"";
	}

	NSString *msg = NSLocalizedString(@"ThankYou", @"ThankYou");
	if (![nlSettings sharednlSettings].currentSendWordResponse)
		msg = [NSString stringWithFormat:@"%@!", NSLocalizedString(@"Error", @"Error")];
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
	alert.tag = 2;
	[alert show];
	[alert release];
}

- (void)serviceError:(id)sender error:(NSString *) errorMessage {
	[BlackAlertView setBackgroundColor:[UIColor blackColor] withStrokeColor:[UIColor whiteColor]];
	BlackAlertView *alert = [[BlackAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Error", @"Error"), errorMessage] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles: nil];
	alert.tag = 1;
	[alert show];
	[alert release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	scrollView = nil;
	[scrollView release];
	contentView = nil;
	[contentView release];
	txtName = nil;
	[txtName release];
	txtEmail = nil;
	[txtEmail release];
	txtURL = nil;
	[txtURL release];
	txtWord = nil;
	[txtWord release];
	txtMeaning = nil;
	[txtMeaning release];
	txtExample = nil;
	[txtExample release];
	txtEthimology = nil;
	[txtEthimology release];
	nests = nil;
	[nests release];
	btnNests = nil;
	[btnNests release];
	webService = nil;
	[webService release];
	btnGaz = nil;
	[btnGaz release];
	lblName = nil;
	[lblName release];
	lblEmail = nil;
	[lblEmail release];
	lblURL = nil;
	[lblURL release];
	lblWord = nil;
	[lblWord release];
	lblNest = nil;
	[lblNest release];
	lblDescription = nil;
	[lblDescription release];
	lblExample = nil;
	[lblExample release];
	lblEthimology = nil;
	[lblEthimology release];
    [super viewDidUnload];
}

- (void)dealloc {
	[scrollView release];
	[contentView release];
	[txtName release];
	[txtEmail release];
	[txtURL release];
	[txtWord release];
	[txtMeaning release];
	[txtExample release];
	[txtEthimology release];
	[nests release];
	[btnNests release];
	[webService release];
	[btnGaz release];
	[lblName release];
	[lblEmail release];
	[lblURL release];
	[lblWord release];
	[lblNest release];
	[lblDescription release];
	[lblExample release];
	[lblEthimology release];
    [super dealloc];
}

@end
