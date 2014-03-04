//
//  dbNest.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbNest :  NSManagedObject  
{
}

@property (nonatomic, strong) NSNumber * ID;
@property (nonatomic, strong) NSString * Title;
@property (nonatomic, strong) NSNumber * OrderPos;

@end



