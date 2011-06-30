//
//  nlSettings.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SynthesizeSingleton.h"
#import "CurrentWord.h"
#import "dbWord.h"

@interface nlSettings : NSObject {
	BOOL inDebugMode, currentSendWordResponse, rememberPrivateData;
	NSString *ServicesURL, *BuildVersion;
	float LocationLatitude, LocationLongtitude;
	CurrentWord *currentWord;
	dbWord *currentDbWord;
	NSArray *letters;
}

@property BOOL inDebugMode, currentSendWordResponse, rememberPrivateData;
@property (nonatomic, retain) NSString *ServicesURL, *BuildVersion;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, retain) CurrentWord *currentWord;
@property (nonatomic, retain) dbWord *currentDbWord;
@property (nonatomic, retain) NSArray *letters;

- (void)LogThis: (NSString *)log;
- (BOOL)connectedToInternet;

+ (nlSettings *)sharednlSettings;

@end
