//
//  WordDesc.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDesc : UIViewController {
	UITextView *txtDesc;
	int descID;
}

@property (nonatomic, strong) IBOutlet UITextView *txtDesc;
@property int descID;

@end
