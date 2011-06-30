//
//  SendWord.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface SendWord : UIViewController <WebServiceDelegate, UITextFieldDelegate, UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	WebService *webService;
	UIScrollView *scrollView;
	UIView *contentView;
	UITextField *txtName, *txtEmail, *txtURL, *txtWord, *txtMeaning, *txtExample, *txtEthimology;
	UIButton *btnNests, *btnGaz;
	UILabel *lblName, *lblEmail, *lblURL, *lblWord, *lblNest, *lblDescription, *lblExample, *lblEthimology;
	NSArray *nests;
	int nestRow;
}

@property (nonatomic, retain) WebService *webService;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIView *contentView;
@property (nonatomic, retain) IBOutlet UITextField *txtName, *txtEmail, *txtURL, *txtWord, *txtMeaning, *txtExample, *txtEthimology;
@property (nonatomic, retain) IBOutlet UIButton *btnNests, *btnGaz;
@property (nonatomic, retain) IBOutlet UILabel *lblName, *lblEmail, *lblURL, *lblWord, *lblNest, *lblDescription, *lblExample, *lblEthimology;
@property (nonatomic, retain) NSArray *nests;
@property int nestRow;

- (IBAction) iboNest:(id)sender;
- (IBAction) iboSend:(id)sender;

@end
