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

@property (nonatomic, strong) NSString * SName;
@property (nonatomic, strong) NSString * SValue;

@end



