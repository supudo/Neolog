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

@property (nonatomic, strong) NSString * Email;
@property (nonatomic, strong) NSString * Name;
@property (nonatomic, strong) NSString * URL;
@property (nonatomic, strong) NSNumber * NestID;

@end



