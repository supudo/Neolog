//
//  dbWordComment.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <CoreData/CoreData.h>

@class dbWord;

@interface dbWordComment :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * WordID;
@property (nonatomic, retain) NSString * Comment;
@property (nonatomic, retain) NSDate * CommentDate;
@property (nonatomic, retain) NSString * Author;
@property (nonatomic, retain) NSNumber * CommentID;
@property (nonatomic, retain) dbWord * word;

@end



