//
//  SchedulerVC.h
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#include "constants.h"
@class iPhoneTabBarController;
@class DLCOne;

@interface SchedulerVC : BaseVC
{
    bool        scheduleEnabled;
    TimeOfDay   profile1Time[NUM_DAYS];
    TimeOfDay   profile2Time[NUM_DAYS];
}

@property (nonatomic) Boolean weekViewVisible;
@property (nonatomic) Boolean nameViewVisible;

- (BOOL)showNameView;
- (BOOL)showWeekView;
@end
