//
//  globalSettings.h
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "constants.h"
#include "BLEDefines.h"

@interface GlobalSettings : NSObject
{
    @protected
    
   // unsigned char dimmingFormat;
   // unsigned char corridorFunction;
  //  unsigned char contextSwitchEnable;
    unsigned char scheduleEnable;
    NSString *password;
    Schedule      weeklySchedule[NUM_PROFILES][NUM_DAYS];
    unsigned char dlcVersionMsb;
    unsigned char dlcVersionLsb;
  //  unsigned char testDimLevel;
    unsigned char daliPowerSaveModeEnable;
    unsigned char singlePoleSwitch;
    unsigned char pirEnableMask;
    unsigned char timeClockEnable;
    unsigned char dstSetting;
    
    unsigned char emergencyTestTime[NUM_EMERGENCY_TEST_TIMES];
    
    UInt8 data[BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN];
    UInt16 csum;
    
    UInt8 scheduleData[NUM_PROFILES][BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN];
    UInt16 scheduleCsum[NUM_PROFILES];
}

//@property (nonatomic) unsigned char dimmingFormat;
//@property (nonatomic) unsigned char corridorFunction;
//@property (nonatomic) unsigned char contextSwitchEnable;
@property (nonatomic) unsigned char scheduleEnable;
//@property (nonatomic) unsigned char testDimLevel;
@property (nonatomic) unsigned char dlcVersionMsb;
@property (nonatomic) unsigned char dlcVersionLsb;
@property (nonatomic) UInt16 csum;

@property (nonatomic) NSString *password;
@property (nonatomic) unsigned char daliPowerSaveModeEnable;
@property (nonatomic) unsigned char singlePoleSwitch;
@property (nonatomic) unsigned char pirEnableMask;
@property (nonatomic) unsigned char timeClockEnable;
@property (nonatomic) unsigned char dstSetting;
-(id)init;
-(void)setScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day withTime:(TimeOfDay)time;
-(TimeOfDay)getScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day;
-(void)setEmergencyTestTime:(NSInteger)test toDuration:(NSInteger)time;
-(unsigned char)getEmergencyTestTimeFor:(NSInteger)test;
-(void)initialiseBlankSchedule;
-(UInt8 *)getDataArray;

@end
