//
//  dbSetting.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>


@interface dbSetting :  NSManagedObject  
{
}

@property (nonatomic, retain) NSString * SName;
@property (nonatomic, retain) NSString * SValue;

@end



