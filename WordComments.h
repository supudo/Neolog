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

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) IBOutlet CellWordComment *cellComment;
@property (nonatomic, strong) dbWordComment *entComment;

- (void)addComment;

@end
