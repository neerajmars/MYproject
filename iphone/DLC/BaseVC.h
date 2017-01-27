//
//  BaseVC.h
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
@class iPhoneTabBarController;
@class DLCOne;

@interface BaseVC : UIViewController
{
    iPhoneTabBarController  * parentVC;
    DLCOne                  *controller;
}

@property (strong, nonatomic) iPhoneTabBarController * parentVC;
@property (nonatomic)DLCOne *controller;

- (void)setParentVC:(iPhoneTabBarController *)p;
- (void)loadValuesFromControllerImage;
- (void)storeValuesToControllerImage;
- (void)loadValuesFromControllerImageForRelayChannelSetting;
- (void)storeValuesFromControllerImageForRelayChannelSetting;

- (void)storeValuesToControllerImageWithEditTimeOut;
-(void)writeUpdatedValue;


@end
