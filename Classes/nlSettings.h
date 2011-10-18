//
//  nlSettings.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#define LocalizedString(n, m) [[nlSettings sharednlSettings] getTranslation:n]

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "CurrentWord.h"
#import "dbWord.h"

@interface nlSettings : NSObject {
	BOOL inDebugMode, currentSendWordResponse, rememberPrivateData, shouldRotate;
	NSString *ServicesURL, *BuildVersion;
	float LocationLatitude, LocationLongtitude;
	CurrentWord *currentWord;
	dbWord *currentDbWord;
	NSArray *letters;
    NSMutableArray *interfaceLanugages;
	NSString *twitterOAuthConsumerKey, *twitterOAuthConsumerSecret, *facebookAppID, *facebookAppSecret;
}

@property BOOL inDebugMode, currentSendWordResponse, rememberPrivateData, shouldRotate;
@property (nonatomic, retain) NSString *ServicesURL, *BuildVersion;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, retain) CurrentWord *currentWord;
@property (nonatomic, retain) dbWord *currentDbWord;
@property (nonatomic, retain) NSArray *letters;
@property (nonatomic, retain) NSMutableArray *interfaceLanugages;
@property (nonatomic, retain) NSString *twitterOAuthConsumerKey, *twitterOAuthConsumerSecret, *facebookAppID, *facebookAppSecret;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;
- (void)setLanguage:(NSString *)lang;
- (NSString *)getLanguage;
- (NSString *)getTranslation:(NSString *)note;

+ (nlSettings *)sharednlSettings;

@end
