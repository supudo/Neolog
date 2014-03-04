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

@property (nonatomic, strong) NSNumber * WordID;
@property (nonatomic, strong) NSNumber * NestID;
@property (nonatomic, strong) NSNumber * CommentCount;
@property (nonatomic, strong) NSString * Example;
@property (nonatomic, strong) NSString * Ethimology;
@property (nonatomic, strong) NSString * AddedBy;
@property (nonatomic, strong) NSString * AddedByURL;
@property (nonatomic, strong) NSString * AddedByEmail;
@property (nonatomic, strong) NSString * Word;
@property (nonatomic, strong) NSString * Description;
@property (nonatomic, strong) NSString * Derivatives;
@property (nonatomic, strong) NSDate * AddedAtDate;

@end



