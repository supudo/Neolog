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

@property (nonatomic, retain) NSString * Content;
@property (nonatomic, retain) NSNumber * ContentID;

@end



