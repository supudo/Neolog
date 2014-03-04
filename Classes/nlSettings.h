//
//  nlSettings.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CurrentWord.h"
#import "dbWord.h"

@interface nlSettings : NSObject {
	BOOL inDebugMode, currentSendWordResponse, rememberPrivateData;
	NSString *ServicesURL, *BuildVersion;
	float LocationLatitude, LocationLongtitude;
	CurrentWord *currentWord;
	dbWord *currentDbWord;
	NSArray *letters;
    NSMutableArray *interfaceLanugages;
}

@property BOOL inDebugMode, currentSendWordResponse, rememberPrivateData;
@property (nonatomic, strong) NSString *ServicesURL, *BuildVersion;
@property float LocationLatitude, LocationLongtitude;
@property (nonatomic, strong) CurrentWord *currentWord;
@property (nonatomic, strong) dbWord *currentDbWord;
@property (nonatomic, strong) NSArray *letters;
@property (nonatomic, strong) NSMutableArray *interfaceLanugages;

- (void)LogThis:(NSString *)log, ...;
- (BOOL)connectedToInternet;
- (void)setLanguage:(NSString *)lang;
- (NSString *)getLanguage;
- (NSString *)getTranslation:(NSString *)note;

+ (nlSettings *)sharedInstance;

@end
