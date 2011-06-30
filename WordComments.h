//
//  WordComments.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "dbWordComment.h"

@class CellWordComment;

@interface WordComments : UITableViewController <NSFetchedResultsControllerDelegate> {
	NSFetchedResultsController *fetchedResultsController;
	CellWordComment *cellComment;
	dbWordComment *entComment;
}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) IBOutlet CellWordComment *cellComment;
@property (nonatomic, retain) dbWordComment *entComment;

- (void)addComment;

@end
