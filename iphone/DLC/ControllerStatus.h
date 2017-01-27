//
//  ControllerStatus.h
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "constants.h"

@interface ControllerStatus : NSObject
{
    @protected
    
    uint8_t     relay;                          //bool
    uint8_t     absencePresence;                //bool
    uint8_t     luxLevelHigh;
    uint8_t     luxLevelLow;
    uint8_t     dimmingLevelPercentage;
    uint8_t     timerCountMinutes;
    uint8_t     timerStage;             //(Stage)
    uint8_t     lightLevel;             //hi/ok/lo (LightLevel)
    uint8_t     PIRTriggered;           //bool
    uint8_t     activeProfile;
    uint8_t     sceneSelection;
    uint8_t     emergencyTest;
//    uint8_t     pirEnableStatus;
     uint8_t     override;
    
    BOOL        newStatusReceived;
    
    uint8_t     channel;
    unsigned char spare1;
    unsigned char spare2;
    unsigned char spare3;
    unsigned char modelNumber;
    
    PIRState PIRStatus;
    uint8_t     dimmingLevelPercentageA;
    uint8_t     dimmingLevelPercentageB;
    uint8_t     walkTestStatus;
    
}

@property (nonatomic) uint8_t relay;                         //(Switch - bool)
@property (nonatomic) uint8_t absencePresence;
@property (nonatomic) uint8_t luxLevelHigh;
@property (nonatomic) uint8_t luxLevelLow;
@property (nonatomic) uint8_t dimmingLevelPercentage;
@property (nonatomic) uint8_t timerCountMinutes;
@property (nonatomic) uint8_t timerStage;           //(Stage)
@property (nonatomic) uint8_t lightLevel;           //hi/ok/lo (LightLevel)
@property (nonatomic) uint8_t PIRTriggered;
@property (nonatomic) uint8_t override;
@property (nonatomic) uint8_t activeProfile;
@property (nonatomic) uint8_t sceneSelection;
@property (nonatomic) uint8_t emergencyTest;
//@property (nonatomic) uint8_t pirEnableStatus;
@property (nonatomic) BOOL newStatusReceived;

@property (nonatomic) uint8_t channel;

@property (nonatomic) uint8_t modelNumber;
@property (nonatomic) PIRState PIRStatus;
@property (nonatomic) uint8_t dimmingLevelPercentageA;
@property (nonatomic) uint8_t dimmingLevelPercentageB;
@property (nonatomic) uint8_t walkTestStatus;

-(id)init;

@end
