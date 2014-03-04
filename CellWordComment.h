//
//  CellWordComment.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellWordComment : UITableViewCell {
	UITextView *txtComment;
}

@property (nonatomic, strong) IBOutlet UITextView *txtComment;

- (void)setComment:(NSString *)comm;

@end
