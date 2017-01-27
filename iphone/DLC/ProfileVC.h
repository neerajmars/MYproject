//
//  ProfileVC.h
//  DLC
//
//  Created by mr king on 26/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "constants.h"

@class iPhoneTabBarController;
@class DLCOne;

@interface ProfileVC : BaseVC
{
    int         timerMax[NUM_TIMERS];
    int         dimLevel[NUM_TIMERS];
    bool        dayLinkEnable;
  //  bool        harvestEnable;
    bool        absenceEnable;
    bool        dsiDali;
    long        photocellValue;
    
    bool        constantLightEnable;
    bool        brightOutEnable;
    int         occupancyTimeout;
    int         onLevel;
    int         powerSaveLevel;
    int         transitionTimeout;
    unsigned char timers[NUM_TIMERS];
    unsigned char levels[NUM_TIMERS];
    
    NSInteger   selectedProfile;
}

@property (nonatomic) Boolean timersViewVisible;
@property (nonatomic) Boolean nameViewVisible;
@property (nonatomic) Boolean linkViewVisible;

- (BOOL)showTimersView;
- (BOOL)showNameView;
@end
