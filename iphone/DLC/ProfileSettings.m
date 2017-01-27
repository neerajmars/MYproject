//
//  ProfileSettings.m
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ProfileSettings.h"

@implementation ProfileSettings
@synthesize absenceEnable;
@synthesize sensorLuxCalibrationValueHigh;
@synthesize sensorLuxCalibrationValueLow;
@synthesize timer1Max;
@synthesize dimLevel2;
@synthesize timer2Max;
@synthesize dimLevel3;
@synthesize timer3Max;
@synthesize finalDimLevel;
//@synthesize harvestEnable;
//@synthesize daylightLinkEnable;
//@synthesize daylightLinkOnDelay;
//@synthesize daylightLinkOffDelay;
//@synthesize switchMap;
//@synthesize PIRMap;
//@synthesize luxSensorMap;
//@synthesize luxCalibrationOffset;
@synthesize csum;

@synthesize onLevel;
@synthesize occupancyTimeOut;
@synthesize powerSaveLevel;
@synthesize transitionTimeout;
@synthesize brightOutEnable;
@synthesize constantLightEnable;
@synthesize channelFunction;
@synthesize selectedChannel;
@synthesize pirEnable;
@synthesize dimOffsetValue;
@synthesize exitDelayTimer;

-(id)init
{
    if (self = [super init]) 
    {
        // Set to defaults
        absenceEnable = NO;
        sensorLuxCalibrationValueHigh = 0;
        sensorLuxCalibrationValueLow = 4000;
        timer1Max = 30;
        dimLevel2 = 0;
        timer2Max = 5;
        dimLevel3 = 0;
        timer3Max = 5;
        
        finalDimLevel = 0;
      //  harvestEnable = NO;
     //   daylightLinkEnable = NO;
       // daylightLinkOnDelay = 2;
       // daylightLinkOffDelay = 2;
        spare1 = 0;
        spare2 = 0;
        spare3 = 0;
        constantLightEnable=NO;
        brightOutEnable=NO;
        dimOffsetValue=0;
        
        //not applicable to DLCOne
     //   switchMap = 0;
     //   PIRMap = 0;
     //   luxSensorMap = 0;
      //  luxCalibrationOffset = 0;
        pirEnable=0;
        selectedChannel=0;
        exitDelayTimer=0;
        
//        for (int i = 0; i < 4; i++)
//        {
//            dimLevelScene[i] = 0;
//        }
    }
    return self; 
}

- (void) dealloc 
{
}

//-(void)setDimLevelScene:(NSInteger)scene toDimLevel:(NSInteger)level
//{
//    dimLevelScene[scene] = level;
//}
//
//-(unsigned char)getDimLevelSceneLevelFor:(NSInteger)scene
//{
//    return (dimLevelScene[scene]);
//}

-(UInt8 *)getDataArray;
{
    data[0] = (absenceEnable > 0) ? TRUE : FALSE;
    data[1] = sensorLuxCalibrationValueHigh;
    data[2] = sensorLuxCalibrationValueLow;
    data[3] = (timer1Max > MAX_TIMER_MINS) ? MAX_TIMER_MINS : timer1Max;
    data[4] = (dimLevel2 > MAX_PERCENT) ? MAX_PERCENT : dimLevel2;
    data[5] = (timer2Max > MAX_TRANSITION_TIMER_MINS) ? MAX_TRANSITION_TIMER_MINS : timer2Max;
    data[6] = (dimLevel3 > MAX_PERCENT) ? MAX_PERCENT : dimLevel3;
    data[7]=(exitDelayTimer > MAX_EXIT_TIMER) ? MAX_EXIT_TIMER : exitDelayTimer;
    data[9] = (constantLightEnable > 0) ? TRUE : FALSE;
    data[10] = (brightOutEnable > 0) ? TRUE : FALSE;
    data[11] = channelFunction;
    data[12]= pirEnable;
    data[14]= dimOffsetValue;
    return (data);
}
@end
