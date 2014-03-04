//
//  About.h
//  Neolog
//
//  Created by supudo on 6/29/11.
//  Copyright 2011 neolog.bg. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface About : UIViewController <UIWebViewDelegate> {
	UIWebView *webView;
	NSURL *clickedURL;
	BOOL alreadyLoaded;
}

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *clickedURL;
@property BOOL alreadyLoaded;

@end
