//
//  nlSettings.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "Reachability.h"
#import "DBManagedObjectContext.h"
#import "dbSetting.h"

@implementation nlSettings

@synthesize inDebugMode, currentSendWordResponse, rememberPrivateData, ServicesURL, BuildVersion;
@synthesize currentWord, currentDbWord, letters, LocationLatitude, LocationLongtitude;

SYNTHESIZE_SINGLETON_FOR_CLASS(nlSettings);

- (void) LogThis: (NSString *)log {
	if (self.inDebugMode)
		NSLog(@"[_____Neolog-DEBUG] : %@", log);
}

- (BOOL)connectedToInternet {
	Reachability *r = [Reachability reachabilityForInternetConnection];
	NetworkStatus internetStatus = [r currentReachabilityStatus];
	BOOL result = FALSE;
	if (internetStatus == ReachableViaWiFi || internetStatus == ReachableViaWWAN)
	    result = TRUE;
	return result;
}

- (id) init {
	if (self = [super init]) {
		self.inDebugMode = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"NLInDebugMode"] boolValue];
		self.currentSendWordResponse = FALSE;

		DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
		dbSetting *entPD = (dbSetting *)[dbManagedObjectContext getEntity:@"Setting" predicate:[NSPredicate predicateWithFormat:@"SName = %@", @"StorePrivateData"]];

		if (entPD != nil && ![entPD.SValue isEqualToString:@""])
			self.rememberPrivateData = [entPD.SValue boolValue];
		else {
			entPD = (dbSetting *)[NSEntityDescription insertNewObjectForEntityForName:@"Setting" inManagedObjectContext:[dbManagedObjectContext managedObjectContext]];
			[entPD setSName:@"StorePrivateData"];
			[entPD setSValue:@"TRUE"];
			
			NSError *error = nil;
			if (![[[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext] save:&error]) {
				[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"Error while saving the account info: %@", [error userInfo]]];
				abort();
			}
			self.rememberPrivateData = TRUE;
		}

		self.ServicesURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NLServicesURL"];
		self.BuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		self.LocationLatitude = 0.f;
		self.LocationLongtitude = 0.f;
		self.currentWord = [[CurrentWord alloc] init];
		self.currentDbWord = nil;
		self.letters = [[NSArray alloc] initWithObjects:@"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Щ", @"Ъ", @"Ю", @"Я", nil];

		NSArray *accountData = [[NSMutableArray alloc] initWithArray:[dbManagedObjectContext getEntities:@"AccountData" sortDescriptors:nil]];
		if ([accountData count] > 0) {
			self.currentWord.name = [[accountData objectAtIndex:0] valueForKey:@"Name"];
			self.currentWord.email = [[accountData objectAtIndex:0] valueForKey:@"Email"];
			self.currentWord.url = [[accountData objectAtIndex:0] valueForKey:@"URL"];
			self.currentWord.nestID = [[[accountData objectAtIndex:0] valueForKey:@"NestID"] intValue];
		}
		[accountData release];
	}
	return self;
}

@end
