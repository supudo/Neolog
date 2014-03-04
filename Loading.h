//
//  Loading.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebService.h"

@interface Loading : UIViewController <WebServiceDelegate> {
	NSTimer *timer;
	WebService *webService;
}

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) WebService *webService;

- (void)startSync;
- (void)startSyncTimer;
- (void)finishSync;
- (void)startTabApp;

@end
