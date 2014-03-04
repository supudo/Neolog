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

@property (nonatomic, strong) WebService *webService;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *contentView;
@property (nonatomic, strong) IBOutlet UITextField *txtName, *txtEmail, *txtURL, *txtWord, *txtMeaning, *txtExample, *txtEthimology;
@property (nonatomic, strong) IBOutlet UIButton *btnNests, *btnGaz;
@property (nonatomic, strong) IBOutlet UILabel *lblName, *lblEmail, *lblURL, *lblWord, *lblNest, *lblDescription, *lblExample, *lblEthimology;
@property (nonatomic, strong) NSArray *nests;
@property int nestRow;

- (IBAction) iboNest:(id)sender;
- (IBAction) iboSend:(id)sender;

@end
