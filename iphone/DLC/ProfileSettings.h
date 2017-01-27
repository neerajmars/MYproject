//
//  Profile.h
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "constants.h"
#include "BLEDefines.h"

@interface ProfileSettings : NSObject
{
    @protected
    
    unsigned char absenceEnable;
    unsigned char sensorLuxCalibrationValueHigh;
    unsigned char sensorLuxCalibrationValueLow;
    unsigned char timer1Max;
    unsigned char dimLevel2;
    unsigned char timer2Max;
    unsigned char dimLevel3;
    unsigned char timer3Max;
    unsigned char finalDimLevel;
  //  bool harvestEnable;
  //  bool daylightLinkEnable;
  //  unsigned char daylightLinkOnDelay;
 //   unsigned char daylightLinkOffDelay;
    unsigned char spare1;
    unsigned char spare2;
    unsigned char spare3;
    
 //   unsigned char switchMap;
//    unsigned char PIRMap;
 //   unsigned char luxSensorMap;
 //   signed char luxCalibrationOffset;
 //   unsigned char dimLevelScene[NUM_SCENES];
  
    UInt8 data[BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN];
    UInt16 csum;
    //for iDimOrbit
    unsigned char onLevel;
    unsigned char occupancyTimeOut;
    unsigned char powerSaveLevel;
    unsigned char transitionTimeout;
    unsigned char brightOutEnable;
     unsigned char constantLightEnable;
    unsigned char channelFunction;
    unsigned char pirEnable;
    unsigned char selectedChannel;
    signed char dimOffsetValue;
    unsigned char exitDelayTimer;
    
}

@property (nonatomic) unsigned char absenceEnable;
@property (nonatomic) unsigned char sensorLuxCalibrationValueHigh;
@property (nonatomic) unsigned char sensorLuxCalibrationValueLow;
@property (nonatomic) unsigned char timer1Max;
@property (nonatomic) unsigned char dimLevel2;
@property (nonatomic) unsigned char timer2Max;
@property (nonatomic) unsigned char dimLevel3;
@property (nonatomic) unsigned char timer3Max;
@property (nonatomic) unsigned char finalDimLevel;
//@property (nonatomic) bool harvestEnable;
//@property (nonatomic) bool daylightLinkEnable;
//@property (nonatomic) unsigned char daylightLinkOnDelay;
//@property (nonatomic) unsigned char daylightLinkOffDelay;



//@property (nonatomic) unsigned char switchMap;
//@property (nonatomic) unsigned char PIRMap;
//@property (nonatomic) unsigned char luxSensorMap;
//@property (nonatomic) signed char luxCalibrationOffset;
@property (nonatomic) UInt16 csum;

@property (nonatomic) unsigned char onLevel;
@property (nonatomic) unsigned char occupancyTimeOut;
@property (nonatomic) unsigned char powerSaveLevel;
@property (nonatomic) unsigned char transitionTimeout;
@property (nonatomic) unsigned char brightOutEnable;
@property (nonatomic) unsigned char constantLightEnable;
@property (nonatomic) unsigned char channelFunction;
@property (nonatomic) unsigned char pirEnable;
@property (nonatomic) unsigned char selectedChannel;
@property (nonatomic) signed char dimOffsetValue;

@property (nonatomic) unsigned char exitDelayTimer;


-(id)init;
-(void)setDimLevelScene:(NSInteger)scene toDimLevel:(NSInteger)level;
-(unsigned char)getDimLevelSceneLevelFor:(NSInteger)scene;
-(UInt8 *)getDataArray;


@end
