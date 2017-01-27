//
//  ControllerStatus.m
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ControllerStatus.h"
#include "constants.h"

@implementation ControllerStatus
@synthesize relay;
@synthesize absencePresence;
@synthesize luxLevelHigh;
@synthesize luxLevelLow;
@synthesize dimmingLevelPercentage;
@synthesize timerCountMinutes;
@synthesize timerStage;
@synthesize lightLevel;
@synthesize PIRTriggered;
@synthesize activeProfile;
@synthesize sceneSelection;
@synthesize emergencyTest;
//@synthesize pirEnableStatus;
@synthesize modelNumber;
@synthesize override;
@synthesize PIRStatus;
@synthesize channel;
@synthesize newStatusReceived;
@synthesize dimmingLevelPercentageA;
@synthesize dimmingLevelPercentageB;
@synthesize walkTestStatus;

-(id)init
{
    if (self = [super init]) 
    {
        // set to defaults
        relay = OFF;   
        absencePresence = ABSENT;
        luxLevelHigh = 0;
        luxLevelLow = 0;
        dimmingLevelPercentage = 0;
        timerCountMinutes = 0;
        timerStage = STAGE1;           
        lightLevel = LO;           
        PIRStatus = NOT_TRIGGERED;
        activeProfile = PROFILE1;
        PIRTriggered = 0;
        newStatusReceived = true;
        channel=0;
        
        //not applicable to DLCOne
        sceneSelection = 0;
        emergencyTest = 0;
   //     pirEnableStatus = 0;
        spare1 = 0;
        spare2 = 0;
        spare3 = 0;
        dimmingLevelPercentageA=0;
        dimmingLevelPercentageB=0;
        walkTestStatus=0;
    }
    return self; 
}

- (void) dealloc 
{
}

@end
