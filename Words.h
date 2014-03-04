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

@property (nonatomic, strong) NSString *navTitle;
@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) dbWord *entWord;

@end
