//
//  Words.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"
#import "dbWord.h"

@interface Words : UITableViewController <WebServiceDelegate, NSFetchedResultsControllerDelegate> {
	NSString *navTitle;
	WebService *webService;
	NSFetchedResultsController *fetchedResultsController;
	dbWord *entWord;
}

@property (nonatomic, retain) NSString *navTitle;
@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) dbWord *entWord;

@end
