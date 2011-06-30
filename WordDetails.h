//
//  WordDetails.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordDetails : UIViewController {
	UILabel *lblWord, *lblAuthor, *lblURL, *lblLExample, *lblLEthimology;
	UITextView *txtDescription, *txtExample, *txtEthimology;
	UIView *contentView;
	UIButton *btnComments;
	UIScrollView *scrollView;
}

@property (nonatomic, retain) IBOutlet UILabel *lblWord, *lblAuthor, *lblURL, *lblLExample, *lblLEthimology;
@property (nonatomic, retain) IBOutlet UITextView *txtDescription, *txtExample, *txtEthimology;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *btnComments;

- (void)doDesign;

- (IBAction) iboComments:(id)sender;

@end
