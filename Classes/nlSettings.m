//
//  nlSettings.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "nlSettings.h"
#import "Reachability.h"
#import "DBManagedObjectContext.h"
#import "dbSetting.h"

@implementation nlSettings

@synthesize inDebugMode, currentSendWordResponse, rememberPrivateData, ServicesURL, BuildVersion;
@synthesize currentWord, currentDbWord, letters, interfaceLanugages, LocationLatitude, LocationLongtitude;

+ (nlSettings *)sharedInstance {
    static dispatch_once_t once;
    static nlSettings * sharedInstance;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)LogThis:(NSString *)log, ... {
	if (self.inDebugMode) {
		NSString *output;
		va_list ap;
		va_start(ap, log);
		output = [[NSString alloc] initWithFormat:log arguments:ap];
		va_end(ap);
		NSLog(@"[_____Neolog-DEBUG] : %@", output);
	}
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
#if (TARGET_IPHONE_SIMULATOR)
        self.inDebugMode = YES;
#else
        self.inDebugMode = NO;
#endif
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
				[[nlSettings sharedInstance] LogThis:@"Error while saving the account info: %@", [error userInfo]];
				abort();
			}
			self.rememberPrivateData = TRUE;
		}

		self.ServicesURL = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"NLServicesURL"];
		self.BuildVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
		self.LocationLatitude = 0.f;
		self.LocationLongtitude = 0.f;
		self.letters = [NSArray arrayWithObjects:@"А", @"Б", @"В", @"Г", @"Д", @"Е", @"Ж", @"З", @"И", @"Й", @"К", @"Л", @"М", @"Н", @"О", @"П", @"Р", @"С", @"Т", @"У", @"Ф", @"Х", @"Ц", @"Ч", @"Ш", @"Щ", @"Ъ", @"Ю", @"Я", nil];
        self.interfaceLanugages = [NSMutableArray arrayWithObjects:[NSArray arrayWithObjects:@"bg", @"Български", nil], nil];
        [self.interfaceLanugages addObject:[NSArray arrayWithObjects:@"en", @"English", nil]];

        NSArray *accountData = [dbManagedObjectContext getEntities:@"AccountData" sortDescriptors:nil];
		if ([accountData count] > 0) {
			self.currentWord.name = [[accountData objectAtIndex:0] valueForKey:@"Name"];
			self.currentWord.email = [[accountData objectAtIndex:0] valueForKey:@"Email"];
			self.currentWord.url = [[accountData objectAtIndex:0] valueForKey:@"URL"];
			self.currentWord.nestID = [[[accountData objectAtIndex:0] valueForKey:@"NestID"] intValue];
		}
		self.currentWord = [[CurrentWord alloc] init];
		self.currentDbWord = nil;
        
        NSString *currentLang = [self getLanguage];
        if (currentLang == nil || [currentLang isEqualToString:@""])
            [self setLanguage:@"bg"];

        int i = 0;
        NSString *l = @"";
        for (UIViewController *v in appDelegate.tabBarController.viewControllers) {
            l = [NSString stringWithFormat:@"Tabbar_%i", i];
            NSLog(@"%@ = %@", l, [self getTranslation:l]);
            v.tabBarItem.title = [self getTranslation:l];
            i++;
        }
	}
	return self;
}

- (void)setLanguage:(NSString *)lang {
    [[NSUserDefaults standardUserDefaults] setObject:lang forKey:@"SelectedLanguage"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)getLanguage {
    return [[NSUserDefaults standardUserDefaults] stringForKey:@"SelectedLanguage"];
}

- (NSString *)getTranslation:(NSString *)note {
    NSString *slang = [self getLanguage];
    NSString *lnote = [NSString stringWithFormat:@"%@_%@", slang, note];
    return NSLocalizedString(lnote, lnote);
}

@end
