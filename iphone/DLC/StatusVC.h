//
//  StatusVC.h
//  DLC
//
//  Created by mr king on 27/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"

@interface StatusVC : BaseVC
{
  //  NSInteger   selectedProfile;
    BOOL daliPowerSaveModeState;
    BOOL pirEnableChannel1State;
    BOOL pirEnableChannel2State;
    int channelFunction;
    int singlePoleSwitch;
    int selectedChannel;
    int pirEnableStatus;
    signed int dimOffsetValue;
    BOOL constantLightEnable;
    unsigned int exitDelayTimer;
   // int pirEnableMask;
    unsigned char pirEnableMask;
    int walkTestEnable;
    int timeClockEnable;
    NSString * modalNameSTR;
}

- (void)setLightsTo:(BOOL)state;
- (void)setWalkTestEnable:(BOOL)state;
- (void)setCalibrateSensorTo:(long)calLevelValue;
//- (void)setDimLevelOverrideTo:(unsigned char)dimLevelValue;
//-(void)setDimLevelOverrideTo:(unsigned char)level ForChannel:(int)channel;
- (void)setLightsTo:(BOOL)state ForChannel:(int)channel;

- (void)setDimLevelOverrideToA:(unsigned char)dimLevelValue;
- (void)setDimLevelOverrideToB:(unsigned char)dimLevelValue;
-(void)setEMCOverride:(unsigned char)value;
@end
