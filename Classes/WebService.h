//
//  WebService.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "URLReader.h"
#import "dbNest.h"
#import "dbStaticContent.h"
#import "dbWord.h"
#import "dbWordComment.h"

@protocol WebServiceDelegate <NSObject>
@optional
- (void)serviceError:(id)sender error:(NSString *)errorMessage;
- (void)getNestsFinished:(id)sender;
- (void)sendWordFinished:(id)sender;
- (void)getStaticContentFinished:(id)sender;
- (void)fetchWordsForNestFinished:(id)sender;
- (void)fetchWordsForLetterFinished:(id)sender;
- (void)fetchWordCommentsFinished:(id)sender;
- (void)sendCommentFinished:(id)sender;
@end

@interface WebService : NSObject <NSXMLParserDelegate, URLReaderDelegate> {
	id<WebServiceDelegate> delegate;
	URLReader *urlReader;
	NSManagedObjectContext *managedObjectContext;
	NSString *currentElement;
	int OperationID;
	dbNest *entNest;
	dbStaticContent *entStaticContent;
	dbWord *entWord;
	dbWordComment *entWordComment;
}

@property (assign) id<WebServiceDelegate> delegate;
@property (nonatomic, retain) URLReader *urlReader;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property int OperationID;
@property (nonatomic, retain) dbNest *entNest;
@property (nonatomic, retain) dbStaticContent *entStaticContent;
@property (nonatomic, retain) dbWord *entWord;
@property (nonatomic, retain) dbWordComment *entWordComment;

typedef enum NLServiceOperations {
	NLOperationGetNests = 0,
	NLOperationSendWord,
	NLOperationGetStaticContent,
	NLOperationFetchWordsForNest,
	NLOperationFetchWordsForLetter,
	NLOperationFetchWordComments,
	NLOperationSendComment
} NLServiceOperations;

- (void)getNests;
- (void)getStaticContent;
- (void)sendWord;
- (void)fetchWordsForNest:(int)NestID;
- (void)fetchWordsForLetter:(NSString *)letter;
- (void)fetchWordComments:(int)wordID;
- (void)sendComment:(int)wordID author:(NSString *)cAuthor comment:(NSString *)cComment;

@end