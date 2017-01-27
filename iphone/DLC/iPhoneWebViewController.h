//
//  iPhoneWebViewController.h
//  DLC
//
//  Created by mr king on 18/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface iPhoneWebViewController : BaseVC <UIWebViewDelegate>
{
    
}

@property (strong, nonatomic) id delegate;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIWebView *webPageView;
@property (strong, nonatomic) IBOutlet UILabel *failedToLoadLabel;

@end
