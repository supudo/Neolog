//
//  Settings.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "Settings.h"
#import "DBManagedObjectContext.h"
#import "dbSetting.h"
#import "About.h"

@implementation Settings

@synthesize swPrivateData, lblPrivateData, btnLang, btnAbout, selectedLanguage;

- (void)viewDidLoad {
	[super viewDidLoad];
	[swPrivateData setOn:[nlSettings sharedInstance].rememberPrivateData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    selectedLanguage = -1;
    [self setLanguageResources];
}

- (void)setLanguageResources {
	self.navigationItem.title = LocalizedString(@"Settings", @"Settings");
	self.lblPrivateData.text = LocalizedString(@"RememberPrivateData", @"RememberPrivateData");
    [self.btnLang setTitle:LocalizedString(@"ButtonLanguage", @"ButtonLanguage") forState:UIControlStateNormal];
    [self.btnAbout setTitle:LocalizedString(@"ButtonAbout", @"ButtonAbout") forState:UIControlStateNormal];
}

- (IBAction) iboPriveData:(id)sender {
	DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
	dbSetting *entPD = (dbSetting *)[dbManagedObjectContext getEntity:@"Setting" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"StorePrivateData"]];
	[entPD setSValue:(([swPrivateData isOn]) ? @"TRUE" : @"FALSE")];
	NSError *error = nil;
	if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
		[[nlSettings sharedInstance] LogThis:@"Error while saving the account info: %@", [error userInfo]];
		abort();
	}
}

- (IBAction) iboAbout:(id)sender {
	About *tvc = [[About alloc] initWithNibName:@"About" bundle:nil];
	[[self navigationController] pushViewController:tvc animated:YES];
}

- (IBAction) iboChangeLanguage:(id)sender {
    UIActionSheet *menu = [[UIActionSheet alloc] initWithTitle:LocalizedString(@"Language", @"Language")
                                                      delegate:self
                                             cancelButtonTitle:LocalizedString(@"LanguageCancel", @"LanguageCancel")
                                        destructiveButtonTitle:nil
                                             otherButtonTitles:LocalizedString(@"LanguageSave", @"LanguageSave"), nil];
    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, 185.0f, 0, 0)];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];
    
    NSString *slang = [[nlSettings sharedInstance] getLanguage];
    NSUInteger lindex = 0;
    for (int i=0; i<[[nlSettings sharedInstance].interfaceLanugages count]; i++) {
        if ([slang isEqualToString:[[[nlSettings sharedInstance].interfaceLanugages objectAtIndex:i] objectAtIndex:0]])
            lindex = i;
    }
    [pickerView selectRow:lindex inComponent:0 animated:NO];
    
    [menu addSubview:pickerView];
    [menu showFromTabBar:self.tabBarController.tabBar];
    [menu setBounds:CGRectMake(0, 0, 320, 680)];
}

#pragma mark -
#pragma mark Language selection

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component {
    return 50.0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [[[nlSettings sharedInstance].interfaceLanugages objectAtIndex:row] objectAtIndex:1];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    selectedLanguage = row;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [[nlSettings sharedInstance].interfaceLanugages count];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0 && selectedLanguage != -1) {
        [[nlSettings sharedInstance] setLanguage:[[[nlSettings sharedInstance].interfaceLanugages objectAtIndex:selectedLanguage] objectAtIndex:0]];
        [self setLanguageResources];
        int i = 0;
        NSString *l;
        for (UIViewController *v in appDelegate.tabBarController.viewControllers) {
            l = [NSString stringWithFormat:@"Tabbar_%i", i];
            v.tabBarItem.title = LocalizedString(l, l);
            i++;
        }
    }
}

#pragma mark -
#pragma mark System

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	swPrivateData = nil;
	lblPrivateData = nil;
    btnLang = nil;
    btnAbout = nil;
    [super viewDidUnload];
}


@end
