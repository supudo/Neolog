//
//  CurrentWord.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CurrentWord : NSObject {
	NSString *name, *email, *url, *word, *meaning, *example, *ethimology;
	int nestID;
}

@property (nonatomic, strong) NSString *name, *email, *url, *word, *meaning, *example, *ethimology;
@property int nestID;

@end
