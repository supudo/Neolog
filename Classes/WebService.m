//
//  WebService.m
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "WebService.h"
#import "DBManagedObjectContext.h"

@implementation WebService

@synthesize delegate, urlReader, managedObjectContext, OperationID;
@synthesize entNest, entStaticContent, entWord, entWordComment;

#pragma mark -
#pragma mark Services

- (void)getNests {
	self.OperationID = NLOperationGetNests;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Nest"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"GetNests URL call = %@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=GetNests"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=GetNests"] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"GetNests response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getNestsFinished:)])
		[delegate getNestsFinished:self];
}

- (void)sendWord {
	self.OperationID = NLOperationSendWord;
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendWord URL call = %@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=SendWord"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];

	NSMutableString *wordData = [[NSMutableString alloc] init];
	[wordData setString:@""];
	[wordData appendFormat:@"added_by=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.name]];
	[wordData appendFormat:@"&added_by_email=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.email]];
	[wordData appendFormat:@"&added_by_url=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.url]];
	[wordData appendFormat:@"&word=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.word]];
	[wordData appendFormat:@"&nest=%i", [nlSettings sharednlSettings].currentWord.nestID];
	[wordData appendFormat:@"&word_desc=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.meaning]];
	[wordData appendFormat:@"&example=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.example]];
	[wordData appendFormat:@"&ethimology=%@", [self.urlReader urlCryptedEncode:[nlSettings sharednlSettings].currentWord.ethimology]];

	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendWord request data = %@", wordData]];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=SendWord"] postData:wordData postMethod:@"POST"];

	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendWord response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getNestsFinished:)])
		[delegate getNestsFinished:self];

	[wordData release];
}

- (void)getStaticContent {
	self.OperationID = NLOperationGetStaticContent;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"StaticContent"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"GetContent URL call = %@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=GetContent"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=GetContent"] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"GetContent response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getStaticContentFinished:)])
		[delegate getStaticContentFinished:self];
}

- (void)fetchWordsForNest:(int)NestID {
	self.OperationID = NLOperationFetchWordsForNest;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordsForNest URL call = %@?action=FetchWordsForNest&nestID=%i", [nlSettings sharednlSettings].ServicesURL, NestID]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Word"];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?action=FetchWordsForNest&nestID=%i", [nlSettings sharednlSettings].ServicesURL, NestID] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordsForNest response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordsForNestFinished:)])
		[delegate fetchWordsForNestFinished:self];
}

- (void)fetchWordsForLetter:(NSString *)letter {
	self.OperationID = NLOperationFetchWordsForLetter;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordsForLetter URL call = %@?action=FetchWordsForLetter&letter=%@", [nlSettings sharednlSettings].ServicesURL, letter]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Word"];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?action=FetchWordsForLetter&letter=%@", [nlSettings sharednlSettings].ServicesURL, letter] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordsForLetter response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordsForLetterFinished:)])
		[delegate fetchWordsForLetterFinished:self];
}

- (void)fetchWordComments:(int)wordID {
	self.OperationID = NLOperationFetchWordComments;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordComments URL call = %@?action=FetchWordComments&wordID=%i", [nlSettings sharednlSettings].ServicesURL, wordID]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteObjects:@"WordComment" predicate:[NSPredicate predicateWithFormat:@"WordID = %i", wordID]];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?action=FetchWordComments&wordID=%i", [nlSettings sharednlSettings].ServicesURL, wordID] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"FetchWordComments response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordCommentsFinished:)])
		[delegate fetchWordCommentsFinished:self];
}

- (void)sendComment:(int)wordID author:(NSString *)cAuthor comment:(NSString *)cComment {
	self.OperationID = NLOperationSendComment;
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendComment URL call = %@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=SendComment"]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	
	NSMutableString *commentData = [[NSMutableString alloc] init];
	[commentData setString:@""];
	[commentData appendFormat:@"w=%i", wordID];
	[commentData appendFormat:@"&author=%@", [self.urlReader urlCryptedEncode:cAuthor]];
	[commentData appendFormat:@"&comment=%@", [self.urlReader urlCryptedEncode:cComment]];
	
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendComment request data = %@", commentData]];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?%@", [nlSettings sharednlSettings].ServicesURL, @"action=SendComment"] postData:commentData postMethod:@"POST"];
	
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"SendComment response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(sendCommentFinished:)])
		[delegate sendCommentFinished:self];
	
	[commentData release];
}

- (void)searchForWords:(NSString *)searchQuery {
	self.OperationID = NLOperationSearch;
	self.managedObjectContext = [[DBManagedObjectContext sharedDBManagedObjectContext] managedObjectContext];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"Search URL call = %@?action=Search&q=%@", [nlSettings sharednlSettings].ServicesURL, [self.urlReader urlCryptedEncode:searchQuery]]];
	if (self.urlReader == nil)
		self.urlReader = [[URLReader alloc] init];
	[self.urlReader setDelegate:self];
	[[DBManagedObjectContext sharedDBManagedObjectContext] deleteAllObjects:@"Word"];
	NSString *xmlData = [self.urlReader getFromURL:[NSString stringWithFormat:@"%@?action=Search&q=%@", [nlSettings sharednlSettings].ServicesURL, [self.urlReader urlCryptedEncode:searchQuery]] postData:@"" postMethod:@"GET"];
	[[nlSettings sharednlSettings] LogThis:[NSString stringWithFormat:@"Search response = %@", xmlData]];
	if (xmlData.length > 0) {
		NSXMLParser *myParser = [[NSXMLParser alloc] initWithData:[xmlData dataUsingEncoding:NSUTF8StringEncoding]];
		[myParser setDelegate:self];
		[myParser setShouldProcessNamespaces:NO];
		[myParser setShouldReportNamespacePrefixes:NO];
		[myParser setShouldResolveExternalEntities:NO];
		[myParser parse];
		[myParser release];
	}
	else if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(searchForWordsNoResultsFinished :)])
		[delegate searchForWordsNoResultsFinished:self];
}

#pragma mark -
#pragma mark Events

- (void)urlRequestError:(id)sender errorMessage:(NSString *)errorMessage {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(serviceError:error:)])
		[delegate serviceError:self error:errorMessage];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
	if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(serviceError:error:)])
		[delegate serviceError:self error:[parseError localizedDescription]];
}

- (void)parserDidStartDocument:(NSXMLParser *)parser {
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict{
	currentElement = elementName;
	if ([elementName isEqualToString:@"nest"]) {
		entNest = (dbNest *)[NSEntityDescription insertNewObjectForEntityForName:@"Nest" inManagedObjectContext:managedObjectContext];
		[entNest setID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
		[entNest setOrderPos:[NSNumber numberWithInt:[[attributeDict objectForKey:@"ord"] intValue]]];
	}
	else if ([elementName isEqualToString:@"cnabout"]) {
		entStaticContent = (dbStaticContent *)[NSEntityDescription insertNewObjectForEntityForName:@"StaticContent" inManagedObjectContext:managedObjectContext];
		[entStaticContent setContentID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
	}
	else if ([elementName isEqualToString:@"wrd"]) {
		entWord = (dbWord *)[NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:managedObjectContext];
		[entWord setWordID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
	}
	else if ([elementName isEqualToString:@"wc"]) {
		entWordComment = (dbWordComment *)[NSEntityDescription insertNewObjectForEntityForName:@"WordComment" inManagedObjectContext:managedObjectContext];
		[entWordComment setCommentID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"id"] intValue]]];
		[entWordComment setWordID:[NSNumber numberWithInt:[[attributeDict objectForKey:@"wid"] intValue]]];
		DBManagedObjectContext *dbManagedObjectContext = [DBManagedObjectContext sharedDBManagedObjectContext];
		dbWord *wrd = (dbWord *)[dbManagedObjectContext getEntity:@"Word" predicateString:[NSString stringWithFormat:@"WordID = %@", [attributeDict objectForKey:@"wid"]]];
		[entWordComment setWord:wrd];
	}
	else if ([elementName isEqualToString:@"Search"] && [[attributeDict objectForKey:@"c"] intValue] == 0) {
		if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(searchForWordsNoResultsFinished:)])
			[delegate searchForWordsNoResultsFinished:self];
	}
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
	if (![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""]) {
		if ([currentElement isEqualToString:@"nn"])
			[entNest setTitle:string];
		else if ([[currentElement lowercaseString] isEqualToString:@"sendword"])
			[nlSettings sharednlSettings].currentSendWordResponse = [string boolValue];
		// Content
		else if ([currentElement isEqualToString:@"cnabout"])
			[entStaticContent setContent:string];
		// Words
		else if ([currentElement isEqualToString:@"wnid"])
			[entWord setNestID:[NSNumber numberWithInt:[string intValue]]];
		else if ([currentElement isEqualToString:@"wwrd"])
			[entWord setWord:string];
		else if ([currentElement isEqualToString:@"wnm"])
			[entWord setAddedBy:string];
		else if ([currentElement isEqualToString:@"wem"])
			[entWord setAddedByEmail:string];
		else if ([currentElement isEqualToString:@"wurl"])
			[entWord setAddedByURL:string];
		else if ([currentElement isEqualToString:@"wdsc"])
			[entWord setDescription:string];
		else if ([currentElement isEqualToString:@"wex"])
			[entWord setExample:string];
		else if ([currentElement isEqualToString:@"wet"])
			[entWord setEthimology:string];
		// Word Comments
		else if ([currentElement isEqualToString:@"wcau"])
			[entWordComment setAuthor:string];
		else if ([currentElement isEqualToString:@"wccomm"])
			[entWordComment setComment:string];
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
	if (self.OperationID != NLOperationSendWord && self.OperationID != NLOperationSendComment) {
		NSError *error = nil;
		if (![managedObjectContext save:&error])
			abort();
	}
	switch (self.OperationID) {
		case NLOperationGetNests: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getNestsFinished:)])
				[delegate getNestsFinished:self];
			break;
		}
		case NLOperationSendWord: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(sendWordFinished:)])
				[delegate sendWordFinished:self];
			break;
		}
		case NLOperationGetStaticContent: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(getStaticContentFinished:)])
				[delegate getStaticContentFinished:self];
			break;
		}
		case NLOperationFetchWordsForNest: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordsForNestFinished:)])
				[delegate fetchWordsForNestFinished:self];
			break;
		}
		case NLOperationFetchWordsForLetter: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordsForLetterFinished:)])
				[delegate fetchWordsForLetterFinished:self];
			break;
		}
		case NLOperationFetchWordComments: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(fetchWordCommentsFinished:)])
				[delegate fetchWordCommentsFinished:self];
			break;
		}
		case NLOperationSendComment: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(sendCommentFinished:)])
				[delegate sendCommentFinished:self];
			break;
		}
		case NLOperationSearch: {
			if (self.delegate != NULL && [self.delegate respondsToSelector:@selector(searchForWordsFinished:)])
				[delegate searchForWordsFinished:self];
			break;
		}
		default:
			break;
	}
}

#pragma mark -
#pragma mark dealloc

- (void)dealloc {
	[entWordComment release];
	[entWord release];
	[entStaticContent release];
	[entNest release];
	[currentElement release];
	[managedObjectContext release]; 
	[super dealloc];
}

@end