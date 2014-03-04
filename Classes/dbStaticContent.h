//
//  dbStaticContent.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbStaticContent :  NSManagedObject  
{
}

@property (nonatomic, strong) NSString * Content;
@property (nonatomic, strong) NSNumber * ContentID;

@end



