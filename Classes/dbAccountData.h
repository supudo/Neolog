//
//  dbAccountData.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbAccountData :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * Email;
@property (nonatomic, retain) NSString * Name;
@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSNumber * NestID;

@end



