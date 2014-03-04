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

@property (nonatomic, strong) IBOutlet UILabel *lblWord, *lblAuthor, *lblURL, *lblLExample, *lblLEthimology;
@property (nonatomic, strong) IBOutlet UITextView *txtDescription, *txtExample, *txtEthimology;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIButton *btnComments;

- (void)doDesign;

- (IBAction)iboComments:(id)sender;
- (IBAction)sendFacebook:(id)sender;
- (IBAction)sendTwitter:(id)sender;

@end
