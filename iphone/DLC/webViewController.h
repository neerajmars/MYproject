//
//  webViewController.h
//  DLC
//
//  Created by NEERAJ KUMAR on 19/12/16.
//  Copyright © 2016 A King. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface webViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mywebview;

@property (weak, nonatomic) NSString *tempName;
@property (weak, nonatomic) NSString *tempTitle;


@end
