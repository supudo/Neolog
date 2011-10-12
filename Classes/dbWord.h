//
//  dbWord.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbWord :  NSManagedObject  
{
}

@property (nonatomic, retain) NSNumber * WordID;
@property (nonatomic, retain) NSNumber * NestID;
@property (nonatomic, retain) NSNumber * CommentCount;
@property (nonatomic, retain) NSString * Example;
@property (nonatomic, retain) NSString * Ethimology;
@property (nonatomic, retain) NSString * AddedBy;
@property (nonatomic, retain) NSString * AddedByURL;
@property (nonatomic, retain) NSString * AddedByEmail;
@property (nonatomic, retain) NSString * Word;
@property (nonatomic, retain) NSString * Description;
@property (nonatomic, retain) NSString * Derivatives;
@property (nonatomic, retain) NSDate * AddedAtDate;

@end



