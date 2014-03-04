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

@property (nonatomic, strong) NSArray *nests;
@property (nonatomic, strong) UIView *headerNests, *headerLetters;
@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) NSString *navTitle;
@property BOOL searchActive;

- (void)toggleSearch;

@end
