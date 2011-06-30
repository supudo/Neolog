//
//  CurrentWord.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "CurrentWord.h"

@implementation CurrentWord

@synthesize name, email, url, word, meaning, example, ethimology, nestID;

- (id) init {
	if (self = [super init]) {
		self.name = @"";
		self.email = @"";
		self.url = @"";
		self.word = @"";
		self.meaning = @"";
		self.example = @"";
		self.ethimology = @"";
		self.nestID = 0;
	}
	return self;
}

@end
