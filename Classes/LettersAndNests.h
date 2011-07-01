//
//  LettersAndNests.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface LettersAndNests : UITableViewController <WebServiceDelegate, UISearchDisplayDelegate, UISearchBarDelegate> {
	NSArray *nests;
	UIView *headerNests, *headerLetters;
	WebService *webService;
	NSString *navTitle;
	BOOL searchActive;
}

@property (nonatomic, retain) NSArray *nests;
@property (nonatomic, retain) UIView *headerNests, *headerLetters;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSString *navTitle;
@property BOOL searchActive;

- (void)toggleSearch;

@end
