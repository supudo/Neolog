//
//  Settings.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController <UIActionSheetDelegate, UIPickerViewDelegate, UIPickerViewDataSource> {
	UISwitch *swPrivateData;
	UILabel *lblPrivateData;
    UIButton *btnLang, *btnAbout;
    int selectedLanguage;
}

@property (nonatomic, strong) IBOutlet UISwitch *swPrivateData;
@property (nonatomic, strong) IBOutlet UILabel *lblPrivateData;
@property (nonatomic, strong) IBOutlet UIButton *btnLang, *btnAbout;
@property int selectedLanguage;

- (IBAction) iboPriveData:(id)sender;
- (IBAction) iboChangeLanguage:(id)sender;
- (IBAction) iboAbout:(id)sender;
- (void) setLanguageResources;

@end
