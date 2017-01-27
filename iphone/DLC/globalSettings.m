//
//  globalSettings.m
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GlobalSettings.h"
#include "constants.h"
#include <stdlib.h>

@implementation GlobalSettings
//@synthesize dimmingFormat;
//@synthesize corridorFunction;
//@synthesize contextSwitchEnable;
@synthesize scheduleEnable;
//@synthesize testDimLevel;
@synthesize password;
@synthesize dlcVersionMsb;
@synthesize dlcVersionLsb;
@synthesize csum;
@synthesize daliPowerSaveModeEnable;
@synthesize singlePoleSwitch;
@synthesize pirEnableMask;
@synthesize timeClockEnable;
@synthesize dstSetting;

-(id)init
{
    if (self = [super init]) 
    {
        // Set to defaults 
      //  dimmingFormat = DSI;
      //  corridorFunction = NO;
       // contextSwitchEnable = PROFILE1;
        scheduleEnable = NO;
        password = @"";
        dlcVersionMsb = 0;
        dlcVersionLsb = 0;
        csum = 0;
        daliPowerSaveModeEnable=NO;
        singlePoleSwitch=0;
        pirEnableMask=0;
        timeClockEnable=0;
        dstSetting=0;
        
        for (int profile = PROFILE1; profile < NUM_PROFILES; profile++)
        {
            for (int day = MONDAY; day < NUM_DAYS; day++)
            {
                weeklySchedule[profile][day].time.hours24Clock = 0;
                weeklySchedule[profile][day].time.minutes = 0;
            }
        }
        
        //not applicable for DLCOne
      //  testDimLevel = 0;
        emergencyTestTime[0] = 0;
        emergencyTestTime[1] = 0;
        emergencyTestTime[2] = 0;
    }
    return self; 
}

- (void) dealloc 
{
    [self setPassword:nil];
}

-(void)setScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day withTime:(TimeOfDay)time
{
    if ((profile < NUM_PROFILES) && (day < NUM_DAYS))
    {
        weeklySchedule[profile][day].time.hours24Clock = time.hours24Clock;
        weeklySchedule[profile][day].time.minutes = time.minutes; 
    }
}

-(TimeOfDay)getScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day
{
    TimeOfDay time;
    
    if ((profile < NUM_PROFILES) && (day < NUM_DAYS))
    {
        time.hours24Clock = weeklySchedule[profile][day].time.hours24Clock;
        time.minutes = weeklySchedule[profile][day].time.minutes;
    }
    else 
    {
        time.hours24Clock = 0;
        time.minutes = 0;
    }
    
    return (time);
}

//-(void)setEmergencyTestTime:(NSInteger)test toDuration:(NSInteger)time
//{
//    emergencyTestTime[test] = time;
//}
//
//-(unsigned char)getEmergencyTestTimeFor:(NSInteger)test
//{
//    if (test < 4)
//        return (emergencyTestTime[test]);
//    else
//        return 0;
//}

-(void)initialiseBlankSchedule
{
    for (int profile = PROFILE1; profile < NUM_PROFILES; profile++)
    {
        for (int day = MONDAY; day < NUM_DAYS; day++)
        {
            weeklySchedule[profile][day].time.hours24Clock = 0;
            weeklySchedule[profile][day].time.minutes = 0;
        }
    }
}

-(UInt8 *)getDataArray
{
    long pwLength = [password length];
    UInt8 pwByte;
    UInt8 pwCsum = 0;
    
    data[0] = singlePoleSwitch;
    data[1] =(daliPowerSaveModeEnable > 0) ? true : false;
    data[2] = pirEnableMask;
    data[3] = (scheduleEnable > 0) ? YES : NO;
    
    for (int i = 0; i < 5; i++)
    {
        pwByte = (i < pwLength) ? [password characterAtIndex:i] : 0;
        pwCsum += pwByte;
        data[4 + i] = ((pwByte & 0xf0) >> 4) | ((pwByte & 0x0f) << 4);
    }
    
    if ([password isEqualToString:DEFAULT_PASSWORD] == false)
    {
        data[9] = pwCsum;
    }
    else
    {
        data[9] = 0;
    }
    
    data[10]=dlcVersionMsb;
    data[11]=dlcVersionLsb;
    data[12]=timeClockEnable;
    data[13]=  dstSetting;
    return (data);
}

@end
