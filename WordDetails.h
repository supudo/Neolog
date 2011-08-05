//
//  WordDetails.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
// Twitter
#import "SA_OAuthTwitterController.h"
// Facebook
#import "FBConnect.h"
#import "FBLoginButton.h"

@class SA_OAuthTwitterEngine;

@interface WordDetails : UIViewController <SA_OAuthTwitterControllerDelegate, FBRequestDelegate, FBDialogDelegate, FBSessionDelegate> {
	UILabel *lblWord, *lblAuthor, *lblURL, *lblLExample, *lblLEthimology;
	UITextView *txtDescription, *txtExample, *txtEthimology;
	UIView *contentView;
	UIButton *btnComments;
	UIScrollView *scrollView;
	SA_OAuthTwitterEngine *_twitterEngine;
	Facebook *_facebookEngine;
	FBLoginButton *_fbButton, *btnFacebook;
}

@property (nonatomic, retain) IBOutlet UILabel *lblWord, *lblAuthor, *lblURL, *lblLExample, *lblLEthimology;
@property (nonatomic, retain) IBOutlet UITextView *txtDescription, *txtExample, *txtEthimology;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIButton *btnComments;
@property (readonly) Facebook *_facebookEngine;

- (void)doDesign;

- (IBAction)iboComments:(id)sender;
- (IBAction)sendFacebook:(id)sender;
- (IBAction)sendTwitter:(id)sender;
- (void)twitterPost;

@end
