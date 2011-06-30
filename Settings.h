//
//  Settings.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIViewController {
	UISwitch *swPrivateData;
	UILabel *lblPrivateData;
}

@property (nonatomic, retain) IBOutlet UISwitch *swPrivateData;
@property (nonatomic, retain) IBOutlet UILabel *lblPrivateData;

- (IBAction) iboPriveData:(id)sender;
- (IBAction) iboAbout:(id)sender;

@end
