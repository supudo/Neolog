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

@property (nonatomic, strong) NSNumber * WordID;
@property (nonatomic, strong) NSString * Comment;
@property (nonatomic, strong) NSDate * CommentDate;
@property (nonatomic, strong) NSString * Author;
@property (nonatomic, strong) NSNumber * CommentID;
@property (nonatomic, strong) dbWord * word;

@end



