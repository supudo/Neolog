//
//  WordSendComment.h
//  Neolog
//
//  Created by supudo on 6/30/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface WordSendComment : UIViewController <UITextFieldDelegate, WebServiceDelegate> {
	UITextField *txtAuthor;
	UITextView *txtComment;
	WebService *webService;
}

@property (nonatomic, strong) IBOutlet UITextField *txtAuthor;
@property (nonatomic, strong) IBOutlet UITextView *txtComment;
@property (nonatomic, strong) WebService *webService;

- (void)sendComment;

@end
