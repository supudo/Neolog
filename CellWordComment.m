//
//  CellWordComment.m
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import "CellWordComment.h"

@implementation CellWordComment

@synthesize txtComment;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}

- (void)setComment:(NSString *)comm {
	txtComment.text = comm;
	txtComment.font = [UIFont fontWithName:@"Verdana" size:12];
	txtComment.contentInset = UIEdgeInsetsMake(-4, -8, 0, 0);

	CGRect frameTemp;

	CGSize c = txtComment.contentSize;
	frameTemp = txtComment.frame;
	frameTemp.size.height = c.height;
	txtComment.frame = frameTemp;

	frameTemp = [self frame];
	frameTemp.size.height = c.height + 30;
	[self setFrame:frameTemp];
}


@end
