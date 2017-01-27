//
//  TimersVC.h
//  DLC
//
//  Created by mr king on 28/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "iPhoneProfileViewController.h"
#include "constants.h"

@class iPhoneTabBarController;
@class DLCOne;

@interface TimersVC : BaseVC
{    
    iPhoneProfileViewController *initialView;
    unsigned char timers[NUM_TIMERS];
    unsigned char levels[NUM_TIMERS];
}

@property (nonatomic) Profile selectedProfile;

@end
