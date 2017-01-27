 
//
//  DLCOne.m
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DLCOne.h"
#import "GDataXMLNode.h"
#include "constants.h"
#include "BLEDevice.h"
#include <stdlib.h>

@implementation DLCOne
@synthesize profileFilename;

- (id)init
{
    if (self = [super init])
    {
        // Custom initialization
        globalSettings = [[GlobalSettings alloc] init];
        profiles[0] = [[ProfileSettings alloc] init];
        profiles[1] = [[ProfileSettings alloc] init];
        liveStatus = [[ControllerStatus alloc] init];
        remoteCommands = [[ControllerRemote alloc] init];
        deviceName = [[NSString alloc] initWithString: NSLocalizedString(@"GEN_UNKNOWN", nil)];
        deviceDescriptor = [[NSString alloc] initWithString: NSLocalizedString(@"FIND_NONE", nil)];
        deviceID = 0;
        profileFilename = @"";
        dlcModelNumber = 0;
    }
    return self; 
}

- (id)initWithDeviceID:(NSString *)newID
{
    self = [self init];
    deviceID = newID;
    
    if (newID != 0)
    {
        
    }
    return (self);
}

- (void) dealloc 
{
    globalSettings = nil;
    profiles[0] = nil;
    profiles[1] = nil;
    liveStatus = nil;
    remoteCommands = nil;
    deviceName = nil;
    deviceDescriptor = nil;
    profileFilename = nil;
}

-(NSString *)getProfileName
{
    return (profileFilename);
}

-(NSString *)getdeviceDescription
{
    return (deviceDescriptor);
}

-(NSString *)getdeviceLocation
{
    return (deviceLocation);
}

- (NSString *)getDeviceID
{
    return (deviceID);
}

- (NSString *)getDeviceName
{
    return (deviceName);
}

- (void)setDeviceDescriptorAs:(NSString *)descriptor
{
    if (descriptor != nil)
    {
        deviceDescriptor = descriptor;
    }
}

- (void)setDeviceNameWith:(NSString *)name
{
    if (name != nil)
    {
        deviceName = name;
        deviceLocation = name;
    }
}

- (void)setDeviceWithID:(NSString *)newID
{
    deviceID = newID;
}


-(void)setProfileName:profileName andDescription:description andLocation:location;
{
    if (profileName != nil)
    {
        profileFilename = profileName;
    }
    
    deviceDescriptor = description;
    deviceLocation = location;
    
    if (location != nil)
    {
        deviceName = location;
    }
}

-(Switch)getDaliPowerSaveMode
{
    return (globalSettings.daliPowerSaveModeEnable);
}
-(void)setDaliPowerSaveMode : (BOOL)state
{
    globalSettings.daliPowerSaveModeEnable=state;
}

-(int)getSinglePoleSwitch
{
    return (globalSettings.singlePoleSwitch);
}
-(void)setSinglePoleSwitch:(int)channel
{
    globalSettings.singlePoleSwitch=channel;
}
-(int)getTimeClockEnable
{
    return (globalSettings.timeClockEnable);
}
-(void)setTimeClockEnable:(int)value
{
    globalSettings.timeClockEnable=value;
}

-(int)getDSTSetting
{
    return (globalSettings.dstSetting);
}
-(void)setDSTSetting:(int)value;
{
    globalSettings.dstSetting=value;
}
-(NSString *)getPassword
{
    return (globalSettings.password);
}
-(void)setPassword:(NSString *)newPassword
{
    globalSettings.password = newPassword;
}

-(UInt8)getModelNumber
{
    NSLog(@"%d",dlcModelNumber);
    return (dlcModelNumber);
}

#pragma mark -
#pragma mark update DLC structures with new data read from DLC
-(void)updateAllStatusWithData:(uint8_t *)newStatus
{
    if (newStatus != nil)
    {
        liveStatus.relay=newStatus[0] > 0 ? ON : OFF;
        liveStatus.absencePresence = newStatus[1] > 0 ? ABSENT : PRESENT;
        liveStatus.luxLevelHigh = newStatus[2];
        liveStatus.luxLevelLow = newStatus[3];
        liveStatus.dimmingLevelPercentageA=newStatus[4];
        liveStatus.timerCountMinutes = newStatus[5];
        liveStatus.timerStage = newStatus[6] < NUM_STAGES ? newStatus[6] : liveStatus.timerStage;
        liveStatus.lightLevel = newStatus[7] < NUM_LIGHT_LEVELS ? newStatus[7] : liveStatus.lightLevel;
        liveStatus.PIRTriggered = newStatus[8]; //> 0 ? true : false;
        liveStatus.activeProfile = newStatus[9] < NUM_PROFILES ? newStatus[9] : liveStatus.activeProfile;
        liveStatus.newStatusReceived = true;
        liveStatus.dimmingLevelPercentageB=newStatus[11];
        liveStatus.walkTestStatus=newStatus[12];
        
    }
}

-(void) updateGlobalSettingsWithData:(uint8_t *)newGlobalSettings
{
    if (newGlobalSettings != nil)
    {
        
        globalSettings.singlePoleSwitch=newGlobalSettings[0];
        globalSettings.daliPowerSaveModeEnable=newGlobalSettings[1];
        globalSettings.pirEnableMask=newGlobalSettings[2];
        globalSettings.scheduleEnable = (newGlobalSettings[3] > 0) ? YES : NO;
        char buffer[5];
        for (int i = 0; i < 5; i++)
        {
            UInt8 pwByte = newGlobalSettings[4 + i];
            buffer[i] = ((pwByte & 0xf0) >> 4) | ((pwByte & 0x0f) << 4);
        }
        
        NSString *theString = [NSString stringWithFormat:@"%c%c%c%c%c", buffer[0], buffer[1], buffer[2], buffer[3], buffer[4]];
        NSData *asciiData = [theString dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
        NSString *asciiString = [[NSString alloc] initWithData:asciiData encoding:NSASCIIStringEncoding];
        globalSettings.password = asciiString;
        
        //!!!!TODO newGlobalSettings[9] contains a checksum now? Do what? Verify it?
        globalSettings.dlcVersionMsb = newGlobalSettings[10];
        globalSettings.dlcVersionLsb = newGlobalSettings[11];
        globalSettings.timeClockEnable=newGlobalSettings[12];
        globalSettings.dstSetting = newGlobalSettings[13];
        
    }
}

-(void) updateProfile:(int)profile WithData:(uint8_t *)newProfileSettings
{
    if ((newProfileSettings != nil) && (profile < NUM_PROFILES))
    {
      //  int channel = newProfileSettings[15];
        profiles[profile].absenceEnable = newProfileSettings[0] > 0 ? YES : NO;
        profiles[profile].sensorLuxCalibrationValueHigh = newProfileSettings[1];
        profiles[profile].sensorLuxCalibrationValueLow = newProfileSettings[2];
        profiles[profile].timer1Max = (newProfileSettings[3] <= MAX_TIMER_MINS) ? newProfileSettings[3] : MAX_TIMER_MINS;
        profiles[profile].dimLevel2 = (newProfileSettings[4] <= MAX_PERCENT) ? newProfileSettings[4] : MAX_PERCENT;
        profiles[profile].timer2Max = (newProfileSettings[5] <= MAX_TRANSITION_TIMER_MINS) ? newProfileSettings[5] : MAX_TRANSITION_TIMER_MINS;
        profiles[profile].dimLevel3 = (newProfileSettings[6] <= MAX_PERCENT) ? newProfileSettings[6] : MAX_PERCENT;
         profiles[profile].exitDelayTimer = (newProfileSettings[7] <= MAX_EXIT_TIMER) ? newProfileSettings[7] : MAX_TIMER_MINS;
        profiles[profile].constantLightEnable=newProfileSettings[9] > 0 ? YES : NO;
        profiles[profile].brightOutEnable=newProfileSettings[10] > 0 ? YES : NO;
         profiles[profile].channelFunction=newProfileSettings[11];
        profiles[profile].pirEnable=newProfileSettings[12];
        profiles[profile].dimOffsetValue=newProfileSettings[14];

       
        
        
    }
}
-(void) updateExtend:(int)profile WithData:(uint8_t *)newExtendSettings
{
    TimeOfDay time;
    int index = 2;
    
    if ((newExtendSettings != nil) && (profile < NUM_PROFILES))
    {
        time.hours24Clock = newExtendSettings[0];
        time.minutes = newExtendSettings[1];
        [globalSettings setScheduleForProfile:profile andDay:SUNDAY withTime:time];
        
        for (DayOfWeek day = MONDAY; day < SUNDAY; day++)
        {
            time.hours24Clock = newExtendSettings[index++];
            time.minutes = newExtendSettings[index++];
            [globalSettings setScheduleForProfile:profile andDay:day withTime:time];
        }
    }
}

//-(DimmingFormat)getDimmingFormat
//{
//    return (globalSettings.dimmingFormat);
//}

-(Switch)getRelayStatus
{
    return (liveStatus.relay);
    
}
-(int)getPirEnableCheckBoxTo :(int)selectedProfile
{
    return (profiles[selectedProfile].pirEnable);
}
-(void)setPirEnableCheckboxTo:(int)value ForProfile:(int)selectedProfile
{
    profiles[selectedProfile].pirEnable=value;
}

-(signed int)getMimicChannel1Value:(int)selectedProfile
{
    return (profiles[selectedProfile].dimOffsetValue);
}
-(void)setMimicChannel1Value:(signed int)value ForProfile:(int)selectedProfile
{
   profiles[selectedProfile].dimOffsetValue=value;
}
-(Profile)getActiveProfile
{
    return (liveStatus.activeProfile);
}
-(unsigned char)getDimmingLevelA
{
    return (liveStatus.dimmingLevelPercentageA);
}
-(unsigned char)getDimmingLevelB
{
    return (liveStatus.dimmingLevelPercentageB);
}

-(unsigned char)getTimerValue
{
    return (liveStatus.timerCountMinutes);
}
-(Stage)getTimerStage
{
    return (liveStatus.timerStage);
}
-(int)getWalkTestStatus
{
    return (liveStatus.walkTestStatus);
}
//-(LightLevel)getLightLevel
//{
//    return (liveStatus.lightLevel);
//}

//-(PIRState)getPIRState
//{
//    NSLog(@"%hhu",liveStatus.PIRTriggered);
//     NSLog(@"%hhu",liveStatus.absencePresence);
//     NSLog(@"%d",ABSENCE_TRIGGERED);
//   
//    NSLog(@"%d",PRESENCE_TRIGGERED);
//     NSLog(@"%d",ABSENT);
//     NSLog(@"%d",PRESENT);

//    if (liveStatus.PIRTriggered == true)
//    {
//        if (liveStatus.absencePresence == ABSENT)
//        {
//            liveStatus.PIRStatus = ABSENCE_TRIGGERED;
//        }
//        else
//        {
//            liveStatus.PIRStatus = PRESENCE_TRIGGERED;
//        }
//    }
//    else
//    {
//        liveStatus.PIRStatus = NOT_TRIGGERED;
//    }
//
//    
//    return (liveStatus.PIRStatus);
//}

-(NSMutableArray *)getPIRState
{
    NSLog(@"%hhu",liveStatus.PIRTriggered);
    NSLog(@"%hhu",liveStatus.absencePresence);
    NSLog(@"%d",ABSENCE_TRIGGERED);
    
    NSLog(@"%d",PRESENCE_TRIGGERED);
    NSLog(@"%d",ABSENT);
    NSLog(@"%d",PRESENT);
    if (liveStatus.PIRTriggered>0)
    {
        if (liveStatus.absencePresence == ABSENT)
        {
            liveStatus.PIRStatus = ABSENCE_TRIGGERED;
        }
        else
        {
            liveStatus.PIRStatus = PRESENCE_TRIGGERED;
        }
    }
    else
    {
        liveStatus.PIRStatus = NOT_TRIGGERED;
    }
    
    NSMutableArray * pirTriggeredArray=[[NSMutableArray alloc]init];
    [pirTriggeredArray insertObject:@(liveStatus.PIRStatus) atIndex:0];
    [pirTriggeredArray insertObject:@(liveStatus.PIRTriggered) atIndex:1];
    
//    NSLog(@"NSMutableArray:-%@",pirTriggeredArray);
    
    return (pirTriggeredArray);
}


-(long)getLuxLevel
{
    long lux = ((long)liveStatus.luxLevelHigh << 8) + liveStatus.luxLevelLow;
    return (lux);
}

-(void)setScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day withTime:(TimeOfDay)time
{
    [globalSettings setScheduleForProfile:profile andDay:day withTime:time];
}

-(TimeOfDay)getScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day
{
    TimeOfDay time = [globalSettings getScheduleForProfile:profile andDay:day];
    return (time);
}

-(unsigned char)getPirEnableMask
{
    return (globalSettings.pirEnableMask);
}
-(void)setPirEnableMask :(unsigned char)value
{
    globalSettings.pirEnableMask=value;
}

//-(int)getPirEnableMask
//{
//    return (globalSettings.pirEnableMask);
//}
//-(void)setPirEnableMask :(int)value
//{
//    globalSettings.pirEnableMask=value;
//}
-(UInt8 *)getScheduleDataArrayFor:(Profile)profile
{
    if (profile < NUM_PROFILES)
    {
        TimeOfDay schedule = [self getScheduleForProfile:profile andDay:SUNDAY];
        extendData[profile][0] = schedule.hours24Clock;
        extendData[profile][1] = schedule.minutes;
    
        int index = 2;
    
        for (int day = MONDAY; day < SUNDAY; day++)
        {
            schedule = [self getScheduleForProfile:profile andDay:day];
            extendData[profile][index++] = schedule.hours24Clock;
            extendData[profile][index++] = schedule.minutes;
        }
    
        extendData[profile][14] = 0;
        extendData[profile][15] = 0;
        return (extendData[profile]);
    }

    return (extendData[0]);     //error
}

-(void)setScheduleEnable:(Switch)state
{
    if (state <= ON)
        globalSettings.scheduleEnable = state;
}

-(BOOL)getScheduleEnable
{
    if (globalSettings.scheduleEnable > OFF)
        return (YES);
    else
        return (NO);
}
-(void)setDimLevelOverrideToA:(unsigned char)value
{
    remoteCommands.dimLevelOverrideA = value;
}
-(void)setDimLevelOverrideToB:(unsigned char)value
{
    remoteCommands.dimLevelOverrideB = value;
}
-(void)setEMCOverride:(unsigned char)value
{
    remoteCommands.emcOverride = value;
}


-(unsigned char)getTimerMaxForProfile:(Profile)selectedProfile andTimer:(Timer)timer
{
    unsigned char timerMax = 0;
    if ((selectedProfile < NUM_PROFILES) && (timer < NUM_TIMERS))
    {
        switch (timer) 
        {
            case TIMER1:
                timerMax = profiles[selectedProfile].timer1Max;
                break;
            case TIMER2:
                timerMax = profiles[selectedProfile].timer2Max;
                break;
            case TIMER3:
                timerMax = profiles[selectedProfile].timer3Max;
                break;
            default:
                timerMax = 0;
                break;
        }
    }
    
    return (timerMax);
}

-(unsigned char)getDimLevelForProfile:(Profile)selectedProfile andTimer:(Timer)timer
{
    unsigned char dimLevel = 0;
    if ((selectedProfile < NUM_PROFILES) && (timer < NUM_TIMERS))
    {
        switch (timer) 
        {
            case TIMER1:
                dimLevel = profiles[selectedProfile].dimLevel2;
                break;
            case TIMER2:
                dimLevel = profiles[selectedProfile].dimLevel3;
                break;
            case TIMER3:
                dimLevel = profiles[selectedProfile].finalDimLevel;
                break;
            default:
                dimLevel = 0;
                break;
        }
    }
    
    return (dimLevel);
}

-(void)setTimerMaxForProfile:(Profile)selectedProfile andTimer:(Timer)timer withValue:(unsigned char)timerMax
{
    if ((selectedProfile < NUM_PROFILES) && (timer < NUM_TIMERS))
    {
        switch (timer) 
        {
            case TIMER1:
                profiles[selectedProfile].timer1Max = timerMax;
                break;
            case TIMER2:
                profiles[selectedProfile].timer2Max = timerMax;
                break;
            case TIMER3:
                profiles[selectedProfile].timer3Max = timerMax;
                break;
            default:
                timerMax = 0;
                break;
        }
    }
}

-(void)setDimLevelForProfile:(Profile)selectedProfile andTimer:(Timer)timer withValue:(unsigned char)dimLevel
{
    if ((selectedProfile < NUM_PROFILES) && (timer < NUM_TIMERS))
    {
        switch (timer) 
        {
            case TIMER1:
                profiles[selectedProfile].dimLevel2 = dimLevel;
                break;
            case TIMER2:
                profiles[selectedProfile].dimLevel3 = dimLevel;
                break;
            case TIMER3:
                profiles[selectedProfile].finalDimLevel = dimLevel;
                break;
            default:
                break;
        }
    }    
}
-(BOOL)getAbsenceEnableForProfile:(Profile)selectedProfile
{
    if (selectedProfile < NUM_PROFILES)
        return (profiles[selectedProfile].absenceEnable);
    else
        return (NO);
}
-(BOOL)getbrightOutEnableForProfile:(Profile)selectedProfile
{
    if (selectedProfile < NUM_PROFILES)
        return (profiles[selectedProfile].brightOutEnable);
    else
        return (NO);
}
-(BOOL)getConstantLightEnableForProfile:(Profile)selectedProfile
{
    if (selectedProfile < NUM_PROFILES)
        return (profiles[selectedProfile].constantLightEnable);
    else
        return (NO);
}
-(int)getChannelFunctionForProfile:(Profile)selectedProfile
{
    if (selectedProfile < NUM_PROFILES)
        return (profiles[selectedProfile].channelFunction);
    else
        return 0;
}
-(int)getExitDelayTimer:(Profile)selectedProfile
{
    return (profiles[selectedProfile].exitDelayTimer);
}
-(void)setExitDelayTimer:(Profile)selectedProfile withValue:(int)value
{
    profiles[selectedProfile].exitDelayTimer = value;
}
//-(BOOL)getDaylightLinkEnableForProfile:(Profile)selectedProfile
//{
//    if (selectedProfile < NUM_PROFILES)
//        return (profiles[selectedProfile].daylightLinkEnable);
//    else
//        return (NO);
//}

//-(unsigned char)getLinkDelayForProfile:(Profile)selectedProfile forOnDelay:(BOOL)on
//{
//    if (selectedProfile < NUM_PROFILES)
//    {
//        if (on == true)
//        {
//            return (profiles[selectedProfile].daylightLinkOnDelay);
//        }
//        else
//        {
//            return (profiles[selectedProfile].daylightLinkOffDelay);
//        }
//    }
//    else
//    {
//        return (0);
//    }
//}
//
//-(void)setLinkDelayForProfile:(Profile)selectedProfile forOnDelay:(BOOL)on withValue:(unsigned char)delay
//{
//    if (selectedProfile < NUM_PROFILES)
//    {
//        if (on == true)
//        {
//            profiles[selectedProfile].daylightLinkOnDelay = delay;
//        }
//        else
//        {
//            profiles[selectedProfile].daylightLinkOffDelay = delay;
//        }
//    }
//}

//-(BOOL)getDaylightHarvesEnableForProfile:(Profile)selectedProfile
//{
//    if (selectedProfile < NUM_PROFILES)
//        return (profiles[selectedProfile].harvestEnable);
//    else
//        return (NO);
//}

-(long)getPhotocellCalibrationForProfile:(Profile)selectedProfile
{
    long calibrationValue = 0;
    if (selectedProfile < NUM_PROFILES)
    {
        calibrationValue = ((long)profiles[selectedProfile].sensorLuxCalibrationValueHigh << 8) + profiles[selectedProfile].sensorLuxCalibrationValueLow;
    }
    
    return (calibrationValue);
}
-(void)setAbsenceEnableForProfile:(Profile)selectedProfile withState:(Switch)state
{
    if (selectedProfile < NUM_PROFILES)
    {
        profiles[selectedProfile].absenceEnable = state;
    } 
}
-(void)setbrightOutEnableForProfile:(Profile)selectedProfile withState:(Switch)state
{
    if (selectedProfile < NUM_PROFILES)
    {
        profiles[selectedProfile].brightOutEnable = state;
    }
}
-(void)setConstantLightEnableForProfile:(Profile)selectedProfile withState:(Switch)state
{
    if (selectedProfile < NUM_PROFILES)
    {
        profiles[selectedProfile].constantLightEnable = state;
    }
}
-(void)setChannelFunctionForProfile:(Profile)selectedProfile withValue:(int)value
{
    if (selectedProfile < NUM_PROFILES)
    {
        profiles[selectedProfile].channelFunction = value;
    }
}

//-(void)setDaylightLinkEnableForProfile:(Profile)selectedProfile withState:(Switch)state
//{
//    if (selectedProfile < NUM_PROFILES)
//    {
//        profiles[selectedProfile].daylightLinkEnable = state;
//    }
//}

//-(void)setDaylightHarvesEnableForProfile:(Profile)selectedProfile withState:(Switch)state
//{
//    if (selectedProfile < NUM_PROFILES)
//    {
//        profiles[selectedProfile].harvestEnable = state;
//    }
//}

//-(void)setDimmingFormatWithState:(Switch)state
//{
//    globalSettings.dimmingFormat = state;
//}

-(void)setPhotocellCalibrationForProfile:(Profile)selectedProfile withCalibrationValue:(uint)calVal
{
    if (calVal > MAX_PHOTOCELL_VALUE)
    {
        calVal = MAX_PHOTOCELL_VALUE;
    }
    if (selectedProfile < NUM_PROFILES)
    {
        profiles[selectedProfile].sensorLuxCalibrationValueLow = (Byte)calVal;
        profiles[selectedProfile].sensorLuxCalibrationValueHigh = (Byte)(calVal >> 8);
    }    
}
-(void)setCalibrateSensorTo:(int)value
{
    remoteCommands.calibrateSensor = value;
}
-(void)setSwitchOverrideTo:(Byte)manualState
{
    remoteCommands.manualOverride = manualState;
}

-(void)setwalkTestEnableOverrideTo:(Byte)level
{
    remoteCommands.walkTestEnable = level;
}
-(void)setDaliResettoTo:(int)channel
{
    remoteCommands.daliReset = channel;
}
-(ControllerRemote*)getRemoteCommands
{
    return (remoteCommands);
}

-(GlobalSettings *)getGlobalSettings
{
    return (globalSettings);
}

-(ProfileSettings *)getProfileSettingsFor:(int)profile
{
    if (profile <= PROFILE2)
    {
        return (profiles[profile]);
    }
    return (nil);
}

-(unsigned char)getDLCFirmwareVersion:(BOOL)version
{
    if (version == true)
    {
        return (globalSettings.dlcVersionMsb);
    }
    else
    {
        return (globalSettings.dlcVersionLsb);
    }
}

-(void)initialiseControllerData
{
   // globalSettings.dimmingFormat = 0;
    liveStatus.modelNumber = 0;
    liveStatus.relay = 0;
  //  liveStatus.dimmingLevelPercentage = 0;
    liveStatus.timerCountMinutes = 0;
    liveStatus.timerStage = 0;
    liveStatus.lightLevel = 0;
    liveStatus.PIRTriggered = 0;
    liveStatus.activeProfile = 0;
    liveStatus.luxLevelHigh = 0;
    liveStatus.luxLevelLow = 0;
    liveStatus.dimmingLevelPercentageA = 0;
    liveStatus.dimmingLevelPercentageB = 0;
    liveStatus.walkTestStatus=0;
    [globalSettings initialiseBlankSchedule];
    globalSettings.scheduleEnable = 0;
    globalSettings.pirEnableMask=0;
    
    for (Profile profile = PROFILE1; profile < NUM_PROFILES; profile++)
    {
        profiles[profile].timer1Max = 0;
        profiles[profile].timer2Max = 0;
        profiles[profile].timer3Max = 0;
        profiles[profile].dimLevel2 = 0;
        profiles[profile].dimLevel3 = 0;
        profiles[profile].finalDimLevel = 0;
        profiles[profile].dimOffsetValue=0;
        profiles[profile].pirEnable=0;
      //  profiles[profile].daylightLinkOnDelay = 2;
      //  profiles[profile].daylightLinkOffDelay = 2;
        profiles[profile].absenceEnable = 0;
        profiles[profile].sensorLuxCalibrationValueHigh = 0;
        profiles[profile].sensorLuxCalibrationValueLow = 0;
        profiles[profile].constantLightEnable=0;
        profiles[profile].channelFunction=0;
    }
}


//---------------------------------------------------------------------------------------------
#pragma -
#pragma mark XML parser
- (NSString *)dataFilePath:(BOOL)forSave andWithFilename:(NSString *)filename
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:filename];
    
    if (forSave || [[NSFileManager defaultManager] fileExistsAtPath:documentsPath]) 
    {
        return documentsPath;
    }
    else 
    {
        NSString *filenameNoExtension = [filename stringByDeletingPathExtension];
       // return [[NSBundle mainBundle] pathForResource:filenameNoExtension ofType:@"xml"];
        return [[NSBundle mainBundle] pathForResource:filenameNoExtension ofType:@"dtl"];
    }
}
- (BOOL)loadiDimOrbitConfigurationFromFile:(NSString *)filePath
{
     NSData *xmlData=[[NSMutableData alloc]initWithContentsOfFile:filePath];
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (doc == nil)
    {
        return (NO);
    }
    
    profileFilename = [[filePath lastPathComponent] stringByDeletingPathExtension];
    NSArray *uuids = [doc nodesForXPath:@"//Orbit//UUID" error:nil];
    if (uuids.count > 0)
    {
        GDataXMLElement *uuid = (GDataXMLElement *) [uuids objectAtIndex:0];
        deviceID = uuid.stringValue;
    }
    
    NSArray *names = [doc nodesForXPath:@"//Orbit//DeviceName" error:nil];
    if (names.count > 0)
    {
        GDataXMLElement *name = (GDataXMLElement *) [names objectAtIndex:0];
        deviceName = name.stringValue;
    }
    
    NSArray *descriptors = [doc nodesForXPath:@"//Orbit//Descriptor" error:nil];
    if (descriptors.count > 0)
    {
        GDataXMLElement *descriptor = (GDataXMLElement *) [descriptors objectAtIndex:0];
        deviceDescriptor = descriptor.stringValue;
    }
    
    NSArray *locations = [doc nodesForXPath:@"//Orbit//Location" error:nil];
    if (locations.count > 0)
    {
        GDataXMLElement *location = (GDataXMLElement *) [locations objectAtIndex:0];
        deviceLocation = location.stringValue;
    }
    
    [self loadGlobalSettings:@"//Orbit//GlobalSettings" inDocument:doc];
    [self loadProfileSettings:@"//Orbit//Profile" inDocument:doc];
    
    xmlData = nil;
    [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
    return (YES);
}

- (BOOL)loadDLCOneConfigurationFromFile:(NSString *)filename
{
    NSString *filePath = [self dataFilePath:FALSE andWithFilename:filename];
    
    NSData *xmlData = [[NSMutableData alloc] initWithContentsOfFile:filePath];
   
    NSError *error;
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData:xmlData options:0 error:&error];
    
    if (doc == nil) 
    { 
        return (NO); 
    }
    
    profileFilename = filename;
    NSArray *uuids = [doc nodesForXPath:@"//Orbit//UUID" error:nil];
    if (uuids.count > 0) 
    {
        GDataXMLElement *uuid = (GDataXMLElement *) [uuids objectAtIndex:0];
        deviceID = uuid.stringValue;
    } 
    
    NSArray *names = [doc nodesForXPath:@"//Orbit//DeviceName" error:nil];
    if (names.count > 0) 
    {
        GDataXMLElement *name = (GDataXMLElement *) [names objectAtIndex:0];
        deviceName = name.stringValue;
    } 

    NSArray *descriptors = [doc nodesForXPath:@"//Orbit//Descriptor" error:nil];
    if (descriptors.count > 0) 
    {
        GDataXMLElement *descriptor = (GDataXMLElement *) [descriptors objectAtIndex:0];
        deviceDescriptor = descriptor.stringValue;
    } 
    
    NSArray *locations = [doc nodesForXPath:@"//Orbit//Location" error:nil];
    if (locations.count > 0) 
    {
        GDataXMLElement *location = (GDataXMLElement *) [locations objectAtIndex:0];
        deviceLocation = location.stringValue;
    } 

    [self loadGlobalSettings:@"//Orbit//GlobalSettings" inDocument:doc];
    [self loadProfileSettings:@"//Orbit//Profile" inDocument:doc];

    xmlData = nil;
    return (YES);
}

- (void)loadGlobalSettings:(NSString *)nodeType inDocument:(GDataXMLDocument *)document
{
    NSArray *listMembers = [document nodesForXPath:nodeType error:nil];
    
    for (GDataXMLElement *listMember in listMembers) 
    {
//        NSArray *dimmingFormats = [listMember elementsForName:@"DimmingFormat"];
//        if (dimmingFormats.count > 0) 
//        {
//            GDataXMLElement *dimmingFormat = (GDataXMLElement *) [dimmingFormats objectAtIndex:0];
//            globalSettings.dimmingFormat = dimmingFormat.stringValue.intValue;
//        }
//        else 
//            continue;
    
//        NSArray *corridorFunctions = [listMember elementsForName:@"CorridorFunction"];
//        if (corridorFunctions.count > 0) 
//        {
//            GDataXMLElement *corridorFunction = (GDataXMLElement *) [corridorFunctions objectAtIndex:0];
//            globalSettings.corridorFunction = corridorFunction.stringValue.intValue;
//        }
//        else 
//            continue;

//        NSArray *contextSwitchEnables = [listMember elementsForName:@"ContextSwitchEnable"];
//        if (contextSwitchEnables.count > 0) 
//        {
//            GDataXMLElement *contextSwitchEnable = (GDataXMLElement *) [contextSwitchEnables objectAtIndex:0];
//            globalSettings.contextSwitchEnable = contextSwitchEnable.stringValue.intValue;
//        }
//        else 
//            continue;
        
        NSArray *scheduleEnables = [listMember elementsForName:@"ScheduleEnable"];
        if (scheduleEnables.count > 0) 
        {
            GDataXMLElement *scheduleEnable = (GDataXMLElement *) [scheduleEnables objectAtIndex:0];
            globalSettings.scheduleEnable = scheduleEnable.stringValue.intValue;
        }
        else 
            continue;
        
        NSArray *movementDetectors = [listMember elementsForName:@"MovementDetector"];
        if (movementDetectors.count > 0)
        {
            GDataXMLElement *movementDetector = (GDataXMLElement *) [movementDetectors objectAtIndex:0];
            globalSettings.pirEnableMask = movementDetector.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *switchDimMasks = [listMember elementsForName:@"SwitchDimMask"];
        if (switchDimMasks.count > 0)
        {
            GDataXMLElement *switchDimMask = (GDataXMLElement *) [switchDimMasks objectAtIndex:0];
            globalSettings.singlePoleSwitch = switchDimMask.stringValue.intValue;
        }
        else
            continue;
        
        
        NSArray *daliPowerSaveEnables = [listMember elementsForName:@"DaliPowerSaveEnable"];
        if (daliPowerSaveEnables.count > 0)
        {
            GDataXMLElement *daliPowerSaveEnable = (GDataXMLElement *) [daliPowerSaveEnables objectAtIndex:0];
            globalSettings.daliPowerSaveModeEnable = daliPowerSaveEnable.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *timeClockEnables = [listMember elementsForName:@"TimeClockEnable"];
        if (timeClockEnables.count > 0)
        {
            GDataXMLElement *timeClockEnable = (GDataXMLElement *) [timeClockEnables objectAtIndex:0];
            globalSettings.timeClockEnable = timeClockEnable.stringValue.intValue;
        }
        else
            continue;
                
      //  [self loadEmergencySettings:@"EmergencyTestTimes" inXMLElement:listMember];
        [self loadScheduleSettings:@"Schedule" inXMLElement:listMember];        
    }    
}
    
//- (void)loadEmergencySettings:(NSString *)nodeType inXMLElement:(GDataXMLElement *)element
//{
//    NSArray *listMembers = [element nodesForXPath:nodeType error:nil];
//    
//    for (GDataXMLElement *listMember in listMembers) 
//    {
//        NSArray *emergencyTestTimes = [listMember elementsForName:@"Duration"];
//        if (emergencyTestTimes.count > 0) 
//        {
//            for (int i = 0; ((i < NUM_EMERGENCY_TEST_TIMES) && (i < emergencyTestTimes.count)); i++)
//            {
//                GDataXMLElement *testTime = (GDataXMLElement *) [emergencyTestTimes objectAtIndex:i];
//                NSInteger time = testTime.stringValue.integerValue;
//                [globalSettings setEmergencyTestTime:i toDuration:time];
//            }
//        } 
//        else 
//            continue;
//    }
//}

- (void)loadScheduleSettings:(NSString *)nodeType inXMLElement:(GDataXMLElement *)element
{
    NSArray *listMembers = [element nodesForXPath:nodeType error:nil];
    int profile = PROFILE1;
    
    for (GDataXMLElement *listMember in listMembers) 
    {
        NSArray *profileMembers = [listMember nodesForXPath:@"ProfileSchedule" error:nil];
        if (profileMembers.count >= NUM_PROFILES) 
        {
            for (GDataXMLElement *profileMember in profileMembers)
            {
                NSArray *timeMembers = [profileMember nodesForXPath:@"Time" error:nil];
                if (timeMembers.count >= NUM_DAYS)
                {
                    int day = MONDAY;
                    for (GDataXMLElement *timeMember in timeMembers)
                    {
                        TimeOfDay tod;
                        NSArray *hourTimes = [timeMember elementsForName:@"Hours"];
                        if (hourTimes.count > 0)
                        {
                            GDataXMLElement *hourTime = (GDataXMLElement *) [hourTimes objectAtIndex:0];
                            tod.hours24Clock = hourTime.stringValue.integerValue;
                        }
                           
                        NSArray *minutesTimes = [timeMember elementsForName:@"Minutes"];
                        if (minutesTimes.count > 0)
                        {
                            GDataXMLElement *minutesTime = (GDataXMLElement *) [minutesTimes objectAtIndex:0];
                            tod.minutes = minutesTime.stringValue.integerValue;
                        }
                        
                        [globalSettings setScheduleForProfile:profile andDay:day withTime:tod];
                      
                        if (++day > NUM_DAYS)
                            break;
                    }

                    if (++profile > NUM_PROFILES)
                        break;
                }
            }
            
        }
    }
}                

- (void)loadProfileSettings:(NSString *)nodeType inDocument:(GDataXMLDocument *)document
{
    NSArray *listMembers = [document nodesForXPath:nodeType error:nil];
    int profile = PROFILE1;
    
    for (GDataXMLElement *listMember in listMembers) 
    {
        NSArray *absenceEnables = [listMember elementsForName:@"AbsenceEnable"];
        if (absenceEnables.count > 0) 
        {
            GDataXMLElement *absenceEnable = (GDataXMLElement *) [absenceEnables objectAtIndex:0];
            profiles[profile].absenceEnable = absenceEnable.stringValue.intValue;
        }
        else 
            continue;
        
        NSArray *channelFunctions = [listMember elementsForName:@"ChannelFunction"];
        if (channelFunctions.count > 0)
        {
            GDataXMLElement *channelFunction = (GDataXMLElement *) [channelFunctions objectAtIndex:0];
            profiles[profile].channelFunction = channelFunction.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *dimOffsets = [listMember elementsForName:@"DimOffset_B"];
        if (dimOffsets.count > 0)
        {
            GDataXMLElement *dimOffset = (GDataXMLElement *) [dimOffsets objectAtIndex:0];
            profiles[profile].dimOffsetValue = dimOffset.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *pirEnables = [listMember elementsForName:@"PirEnable"];
        if (pirEnables.count > 0)
        {
            GDataXMLElement *pirEnable = (GDataXMLElement *) [pirEnables objectAtIndex:0];
            profiles[profile].pirEnable = pirEnable.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *constantLightEnables = [listMember elementsForName:@"ConstantLightEnable"];
        if (constantLightEnables.count > 0)
        {
            GDataXMLElement *constantLightEnable = (GDataXMLElement *) [constantLightEnables objectAtIndex:0];
            profiles[profile].constantLightEnable = constantLightEnable.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *brightOutEnables = [listMember elementsForName:@"BrightOutEnable"];
        if (brightOutEnables.count > 0)
        {
            GDataXMLElement *brightOutEnable = (GDataXMLElement *) [brightOutEnables objectAtIndex:0];
            profiles[profile].brightOutEnable = brightOutEnable.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *exitDelayTimes = [listMember elementsForName:@"ExitDelayTime"];
        if (exitDelayTimes.count > 0)
        {
            GDataXMLElement *exitDelayTime = (GDataXMLElement *) [exitDelayTimes objectAtIndex:0];
            profiles[profile].exitDelayTimer = exitDelayTime.stringValue.intValue;
        }
        else
            continue;
        
        NSArray *calibrationHighs = [listMember elementsForName:@"CalibrationHigh"];
        if (calibrationHighs.count > 0) 
        {
            GDataXMLElement *calibrationHigh = (GDataXMLElement *) [calibrationHighs objectAtIndex:0];
            profiles[profile].sensorLuxCalibrationValueHigh = calibrationHigh.stringValue.integerValue;
        }
        else 
             continue;             
             
        NSArray *calibrationLows = [listMember elementsForName:@"CalibrationLow"];
        if (calibrationLows.count > 0) 
        {
            GDataXMLElement *calibrationLow = (GDataXMLElement *) [calibrationLows objectAtIndex:0];
            profiles[profile].sensorLuxCalibrationValueLow = calibrationLow.stringValue.integerValue;
        }
        else 
             continue;             
             
        NSArray *timer1Maxs = [listMember elementsForName:@"Timer1Max"];
        if (timer1Maxs.count > 0) 
        {
            GDataXMLElement *timer1Max = (GDataXMLElement *) [timer1Maxs objectAtIndex:0];
            profiles[profile].timer1Max = timer1Max.stringValue.integerValue;
        }
        else 
            continue;             

        NSArray *dimLevel2s = [listMember elementsForName:@"DimLevel2"];
        if (dimLevel2s.count > 0) 
        {
            GDataXMLElement *dimLevel2 = (GDataXMLElement *) [dimLevel2s objectAtIndex:0];
            profiles[profile].dimLevel2 = dimLevel2.stringValue.integerValue;
        }
        else 
            continue;             

        NSArray *timer2Maxs = [listMember elementsForName:@"Timer2Max"];
        if (timer2Maxs.count > 0) 
        {
            GDataXMLElement *timer2Max = (GDataXMLElement *) [timer2Maxs objectAtIndex:0];
            profiles[profile].timer2Max = timer2Max.stringValue.integerValue;
        }
        else 
            continue;             

        NSArray *dimLevel3s = [listMember elementsForName:@"DimLevel3"];
        if (dimLevel3s.count > 0) 
        {
            GDataXMLElement *dimLevel3 = (GDataXMLElement *) [dimLevel3s objectAtIndex:0];
            profiles[profile].dimLevel3 = dimLevel3.stringValue.integerValue;
        }
        else 
            continue;             
        
        NSArray *timer3Maxs = [listMember elementsForName:@"Timer3Max"];
        if (timer2Maxs.count > 0) 
        {
            GDataXMLElement *timer3Max = (GDataXMLElement *) [timer3Maxs objectAtIndex:0];
            profiles[profile].timer3Max = timer3Max.stringValue.integerValue;
        }
        else 
            continue;             

        NSArray *finalDimLevels = [listMember elementsForName:@"FinalDimLevel"];
        if (finalDimLevels.count > 0) 
        {
            GDataXMLElement *finalDimLevel = (GDataXMLElement *) [finalDimLevels objectAtIndex:0];
            profiles[profile].finalDimLevel = finalDimLevel.stringValue.integerValue;
        }
        else 
            continue; 
        
//        NSArray *harvestEnables = [listMember elementsForName:@"HarvestEnable"];
//        if (harvestEnables.count > 0) 
//        {
//            GDataXMLElement *harvestEnable = (GDataXMLElement *) [harvestEnables objectAtIndex:0];
//            profiles[profile].harvestEnable = harvestEnable.stringValue.integerValue;
//        }
//        else 
//            continue; 

//        NSArray *linkEnables = [listMember elementsForName:@"DaylightLinkEnable"];
//        if (linkEnables.count > 0) 
//        {
//            GDataXMLElement *linkEnable = (GDataXMLElement *) [linkEnables objectAtIndex:0];
//            profiles[profile].daylightLinkEnable = linkEnable.stringValue.integerValue;
//        }
//        else 
//            continue; 

//        NSArray *onDelays = [listMember elementsForName:@"DaylightLinkOnDelay"];
//        if (onDelays.count > 0) 
//        {
//            GDataXMLElement *onDelay = (GDataXMLElement *) [onDelays objectAtIndex:0];
//            profiles[profile].daylightLinkOnDelay = onDelay.stringValue.integerValue;
//        }
//        else 
//            continue; 
//
//        NSArray *offDelays = [listMember elementsForName:@"DaylightLinkOffDelay"];
//        if (offDelays.count > 0) 
//        {
//            GDataXMLElement *offDelay = (GDataXMLElement *) [offDelays objectAtIndex:0];
//            profiles[profile].daylightLinkOffDelay = offDelay.stringValue.integerValue;
//        }
//        else 
//            continue; 
//
//        NSArray *switchMaps = [listMember elementsForName:@"SwitchMap"];
//        if (switchMaps.count > 0) 
//        {
//            GDataXMLElement *switchMap = (GDataXMLElement *) [switchMaps objectAtIndex:0];
//            profiles[profile].switchMap = switchMap.stringValue.integerValue;
//        }
//        else 
//            continue; 
//
//        NSArray *pirMaps = [listMember elementsForName:@"PIRMap"];
//        if (pirMaps.count > 0) 
//        {
//            GDataXMLElement *pirMap = (GDataXMLElement *) [pirMaps objectAtIndex:0];
//            profiles[profile].PIRMap = pirMap.stringValue.integerValue;
//        }
//        else 
//            continue; 

//        NSArray *luxMaps = [listMember elementsForName:@"LuxSensorMap"];
//        if (luxMaps.count > 0) 
//        {
//            GDataXMLElement *luxMap = (GDataXMLElement *) [luxMaps objectAtIndex:0];
//            profiles[profile].luxSensorMap = luxMap.stringValue.integerValue;
//        }
//        else 
//            continue; 

//        NSArray *luxOffsets = [listMember elementsForName:@"LuxCalibrationOffset"];
//        if (luxOffsets.count > 0) 
//        {
//            GDataXMLElement *luxOffset = (GDataXMLElement *) [luxOffsets objectAtIndex:0];
//            profiles[profile].luxCalibrationOffset = luxOffset.stringValue.integerValue;
//        }
//        else 
//            continue; 

      //  [self loadDimLevelSettingsForProfile:profile andNodeType:@"DimLevelScenes" inXMLElement:listMember];

        if (++profile > NUM_PROFILES)
            break;
    }
}

//- (void)loadDimLevelSettingsForProfile:(Profile)p andNodeType:(NSString *)nodeType inXMLElement:(GDataXMLElement *)element
//{
//    NSArray *listMembers = [element nodesForXPath:nodeType error:nil];
//    
//    for (GDataXMLElement *listMember in listMembers) 
//    {
//        NSArray *dimScenes = [listMember elementsForName:@"DimScene"];
//        if (dimScenes.count > 0) 
//        {
//            for (int d = 0; ((d < NUM_SCENES) && (d < dimScenes.count)); d++)
//            {
//                GDataXMLElement *dimScene = (GDataXMLElement *) [dimScenes objectAtIndex:d];
//                NSInteger value = dimScene.stringValue.integerValue;
//                [profiles[p] setDimLevelScene:d toDimLevel:value];
//            }
//        } 
//        else 
//            continue;
//    }
//}


- (void)saveDLCOneConfigurationToFilename:(NSString *)filename
{    
    GDataXMLElement *DLCElement = [GDataXMLNode elementWithName:@"Orbit"];
    GDataXMLElement *deviceIDElement = [GDataXMLNode elementWithName:@"UUID" stringValue:[NSString stringWithFormat:@"%@", deviceID]];
    GDataXMLElement *deviceNameElement = [GDataXMLNode elementWithName:@"DeviceName" stringValue:deviceName];
    GDataXMLElement *descriptorElement = [GDataXMLNode elementWithName:@"Descriptor" stringValue:deviceDescriptor];
    GDataXMLElement *locationElement = [GDataXMLNode elementWithName:@"Location" stringValue:deviceLocation];    
    GDataXMLElement *globalSettingsElement = [self createGlobalSettingsElement];
    GDataXMLElement *profile1Element = [self createSettingsElementForProfile:PROFILE1];
    GDataXMLElement *profile2Element = [self createSettingsElementForProfile:PROFILE2];
    
    [DLCElement addChild:deviceIDElement];    
    [DLCElement addChild:deviceNameElement];    
    [DLCElement addChild:descriptorElement];
    [DLCElement addChild:locationElement];
    [DLCElement addChild:globalSettingsElement];    
    [DLCElement addChild:profile1Element];    
    [DLCElement addChild:profile2Element];    
    
    GDataXMLDocument *document = [[GDataXMLDocument alloc] initWithRootElement:DLCElement];
    NSData *xmlData = document.XMLData;
    NSString *filePath = [self dataFilePath:TRUE andWithFilename:filename];
    NSLog(@"Saving xml data to %@...", filePath);
    [xmlData writeToFile:filePath atomically:YES];
}

- (GDataXMLElement*)createGlobalSettingsElement
{
    GDataXMLElement *globalElement = [GDataXMLNode elementWithName:@"GlobalSettings"];
   // GDataXMLElement *dimElement = [GDataXMLNode elementWithName:@"DimmingFormat" stringValue:[NSString stringWithFormat:@"%d", globalSettings.dimmingFormat]];
   // GDataXMLElement *corridorElement = [GDataXMLNode elementWithName:@"CorridorFunction" stringValue:[NSString stringWithFormat:@"%d", globalSettings.corridorFunction]];
  //  GDataXMLElement *contextElement = [GDataXMLNode elementWithName:@"ContextSwitchEnable" stringValue:[NSString stringWithFormat:@"%d", globalSettings.contextSwitchEnable]];
    GDataXMLElement *scheduleElement = [GDataXMLNode elementWithName:@"ScheduleEnable" stringValue:[NSString stringWithFormat:@"%d", globalSettings.scheduleEnable]];
    GDataXMLElement *movementDetectorElement = [GDataXMLNode elementWithName:@"MovementDetector" stringValue:[NSString stringWithFormat:@"%d", globalSettings.pirEnableMask]];
    GDataXMLElement *switchDimMaskElement = [GDataXMLNode elementWithName:@"SwitchDimMask" stringValue:[NSString stringWithFormat:@"%d", globalSettings.singlePoleSwitch]];
    GDataXMLElement *daliPowerSaveEnableElement = [GDataXMLNode elementWithName:@"DaliPowerSaveEnable" stringValue:[NSString stringWithFormat:@"%d", globalSettings.daliPowerSaveModeEnable]];
     GDataXMLElement *timeClockEnableElement = [GDataXMLNode elementWithName:@"TimeClockEnable" stringValue:[NSString stringWithFormat:@"%d", globalSettings.timeClockEnable]];
    
   // GDataXMLElement *testDimElement = [GDataXMLNode elementWithName:@"TestDimLevel" stringValue:[NSString stringWithFormat:@"%d", globalSettings.testDimLevel]];
   // GDataXMLElement *emergencyElement = [self createEmergencyElement];
    GDataXMLElement *weeklyScheduleElement = [self createScheduleElement];
    
   // [globalElement addChild:dimElement];
  //  [globalElement addChild:corridorElement];
  //  [globalElement addChild:contextElement];
    [globalElement addChild:scheduleElement];
    [globalElement addChild:movementDetectorElement];
    [globalElement addChild:switchDimMaskElement];
    [globalElement addChild:daliPowerSaveEnableElement];
     [globalElement addChild:timeClockEnableElement];
    
   // [globalElement addChild:testDimElement];
  //  [globalElement addChild:emergencyElement];
    [globalElement addChild:weeklyScheduleElement];
    
    return (globalElement);
}

//- (GDataXMLElement*)createEmergencyElement
//{
//    GDataXMLElement *element = [GDataXMLNode elementWithName:@"EmergencyTestTimes"];
//    for (int i = 0; i < NUM_EMERGENCY_TEST_TIMES; i++)
//    {
//        GDataXMLElement *timeElement = [GDataXMLNode elementWithName:@"Duration" stringValue:[NSString stringWithFormat:@"%d", [globalSettings getEmergencyTestTimeFor:i]]];
//        [element addChild:timeElement];
//    }
//    
//    return (element);
//}

- (GDataXMLElement*)createScheduleElement
{
    GDataXMLElement *element = [GDataXMLNode elementWithName:@"Schedule"];
    for (Profile p = PROFILE1; p < NUM_PROFILES; p++)
    {
        GDataXMLElement *profileElement = [GDataXMLNode elementWithName:@"ProfileSchedule"];
        
        for (DayOfWeek d = MONDAY; d < NUM_DAYS; d++)
        {
            TimeOfDay tod = [globalSettings getScheduleForProfile:p andDay:d];
            GDataXMLElement *timeElement = [GDataXMLNode elementWithName:@"Time"];
            GDataXMLElement *hoursElement = [GDataXMLNode elementWithName:@"Hours" stringValue:[NSString stringWithFormat:@"%02ld", (long)tod.hours24Clock]];
            GDataXMLElement *minsElement = [GDataXMLNode elementWithName:@"Minutes" stringValue:[NSString stringWithFormat:@"%02ld", (long)tod.minutes]];
                                                                                            
            [timeElement addChild:hoursElement];
            [timeElement addChild:minsElement];
            [profileElement addChild:timeElement];
        }
        
        [element addChild:profileElement];
    }
    
    return (element);
}

- (GDataXMLElement*)createSettingsElementForProfile:(Profile)p
{
    GDataXMLElement *profileElement = [GDataXMLNode elementWithName:@"Profile"];
    GDataXMLElement *absenceElement = [GDataXMLNode elementWithName:@"AbsenceEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].absenceEnable]];
    GDataXMLElement *channelFunctionElement = [GDataXMLNode elementWithName:@"ChannelFunction" stringValue:[NSString stringWithFormat:@"%d", profiles[p].channelFunction]];
    GDataXMLElement *dimOffsetBElement = [GDataXMLNode elementWithName:@"DimOffset_B" stringValue:[NSString stringWithFormat:@"%d", profiles[p].dimOffsetValue]];
    GDataXMLElement *pirEnableElement = [GDataXMLNode elementWithName:@"PirEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].pirEnable]];
    
    GDataXMLElement *ConstantLightElement = [GDataXMLNode elementWithName:@"ConstantLightEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].constantLightEnable]];
    GDataXMLElement *brightOutElement = [GDataXMLNode elementWithName:@"BrightOutEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].brightOutEnable]];
    GDataXMLElement *exitDelayTimeElement = [GDataXMLNode elementWithName:@"ExitDelayTime" stringValue:[NSString stringWithFormat:@"%d", profiles[p].exitDelayTimer]];
    GDataXMLElement *calibHiElement = [GDataXMLNode elementWithName:@"CalibrationHigh" stringValue:[NSString stringWithFormat:@"%d", profiles[p].sensorLuxCalibrationValueHigh]];
    GDataXMLElement *calibLoElement = [GDataXMLNode elementWithName:@"CalibrationLow" stringValue:[NSString stringWithFormat:@"%d", profiles[p].sensorLuxCalibrationValueLow]];
    GDataXMLElement *timer1Element = [GDataXMLNode elementWithName:@"Timer1Max" stringValue:[NSString stringWithFormat:@"%d", profiles[p].timer1Max]];
    GDataXMLElement *dim2Element = [GDataXMLNode elementWithName:@"DimLevel2" stringValue:[NSString stringWithFormat:@"%d", profiles[p].dimLevel2]];
    GDataXMLElement *timer2Element = [GDataXMLNode elementWithName:@"Timer2Max" stringValue:[NSString stringWithFormat:@"%d", profiles[p].timer2Max]];
    GDataXMLElement *dim3Element = [GDataXMLNode elementWithName:@"DimLevel3" stringValue:[NSString stringWithFormat:@"%d", profiles[p].dimLevel3]];
    GDataXMLElement *timer3Element = [GDataXMLNode elementWithName:@"Timer3Max" stringValue:[NSString stringWithFormat:@"%d", profiles[p].timer3Max]];
    GDataXMLElement *finalDimElement = [GDataXMLNode elementWithName:@"FinalDimLevel" stringValue:[NSString stringWithFormat:@"%d", profiles[p].finalDimLevel]];
   // GDataXMLElement *harvestElement = [GDataXMLNode elementWithName:@"HarvestEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].harvestEnable]];
  //  GDataXMLElement *daylightLinkElement = [GDataXMLNode elementWithName:@"DaylightLinkEnable" stringValue:[NSString stringWithFormat:@"%d", profiles[p].daylightLinkEnable]];
  //  GDataXMLElement *daylightLinkOnElement = [GDataXMLNode elementWithName:@"DaylightLinkOnDelay" stringValue:[NSString stringWithFormat:@"%d", profiles[p].daylightLinkOnDelay]];
  //  GDataXMLElement *daylightLinkOffElement = [GDataXMLNode elementWithName:@"DaylightLinkOffDelay" stringValue:[NSString stringWithFormat:@"%d", profiles[p].daylightLinkOffDelay]];
 //   GDataXMLElement *mapElement = [GDataXMLNode elementWithName:@"SwitchMap" stringValue:[NSString stringWithFormat:@"%d", profiles[p].switchMap]];
//    GDataXMLElement *PIRMapElement = [GDataXMLNode elementWithName:@"PIRMap" stringValue:[NSString stringWithFormat:@"%d", profiles[p].PIRMap]];
  //  GDataXMLElement *luxMapElement = [GDataXMLNode elementWithName:@"LuxSensorMap" stringValue:[NSString stringWithFormat:@"%d", profiles[p].luxSensorMap]];
  //  GDataXMLElement *luxOffsetElement = [GDataXMLNode elementWithName:@"LuxCalibrationOffset" stringValue:[NSString stringWithFormat:@"%d", profiles[p].luxCalibrationOffset]];
 //   GDataXMLElement *sceneElement = [self createDimLevelSceneElementForProfile:p];
    
    [profileElement addChild:absenceElement];
    [profileElement addChild:channelFunctionElement];
    [profileElement addChild:dimOffsetBElement];
    [profileElement addChild:pirEnableElement];
    [profileElement addChild:ConstantLightElement];
    [profileElement addChild:brightOutElement];
    [profileElement addChild:exitDelayTimeElement];
    
    [profileElement addChild:calibHiElement];
    [profileElement addChild:calibLoElement];
    [profileElement addChild:timer1Element];
    [profileElement addChild:dim2Element];
    [profileElement addChild:timer2Element];
    [profileElement addChild:dim3Element];
    [profileElement addChild:timer3Element];
    [profileElement addChild:finalDimElement];
   // [profileElement addChild:harvestElement];
 //   [profileElement addChild:daylightLinkElement];
  //  [profileElement addChild:daylightLinkOnElement];
//    [profileElement addChild:daylightLinkOffElement];
 //   [profileElement addChild:mapElement];
//    [profileElement addChild:PIRMapElement];
 //   [profileElement addChild:luxMapElement];
  //  [profileElement addChild:luxOffsetElement];
 //   [profileElement addChild:sceneElement];
    
    return (profileElement);
}

//- (GDataXMLElement*)createDimLevelSceneElementForProfile:(Profile)p
//{
//    GDataXMLElement *element = [GDataXMLNode elementWithName:@"DimLevelScenes"];
//    for (int i = 0; i < NUM_SCENES; i++)
//    {
//        GDataXMLElement *sceneElement = [GDataXMLNode elementWithName:@"DimScene" stringValue:[NSString stringWithFormat:@"%d", [profiles[p] getDimLevelSceneLevelFor:i]]];
//        [element addChild:sceneElement];
//    }
//    
//    return (element);
//}

- (void)updateDLCGlobalSettingsChecksum:(UInt8*)data WithLength:(UInt8)length
{
    globalSettings.csum = [self fletcher16Checksum:data WithLength:length];
}

-(void)updateDLCProfileChecksumForProfile:(Profile)profile ForData:(UInt8*)data WithLength:(UInt8)length
{
    if (profile < NUM_PROFILES)
    {
        profiles[profile].csum = [self fletcher16Checksum:data WithLength:length];
    }
}

-(void)updateDLCExtendChecksumForProfile:(Profile)profile ForData:(UInt8*)data WithLength:(UInt8)length
{
    if (profile < NUM_PROFILES)
    {
        extendCsum[profile]  = [self fletcher16Checksum:data WithLength:length];
    }
}

-(void) updateDeviceNameWith:(NSString *)newDeviceName
{
    deviceName = newDeviceName;
}

-(void)updateModelNo:(char)modelNumber
{
    if ((UInt8)modelNumber >= 0x30)
    {
        dlcModelNumber = (UInt8)modelNumber - 0x30;
    }
    else
    {
        dlcModelNumber = 0x00;
    }
    
    dlcModelNumber += kDLC100;
}

-(bool)userChangedSettings
{
    bool changed = false;

    if ([self userChangedGlobalSettings] || [self userChangedExtendProfileSettings] || [self userChangedProfileSettings])
    {
        changed = true;
    }
    
    return (changed);
}

-(bool)userChangedGlobalSettings
{
    bool changed = false;

    
    if ([self fletcher16Checksum:[globalSettings getDataArray] WithLength:BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN] != globalSettings.csum)
    {
        changed = true;
    }
    else if (
            ([self fletcher16Checksum:extendData[PROFILE1] WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN] != extendCsum[PROFILE1])
         || ([self fletcher16Checksum:extendData[PROFILE2] WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN] != extendCsum[PROFILE2])
            )
    {
        changed = true;
    }
    
    return (changed);
}

-(bool)userChangedProfileSettings
{
    bool changed = false;
    
    if (
        ([self fletcher16Checksum:[profiles[PROFILE1] getDataArray] WithLength:BLE_DEVICE_DLC_CHAR_PRIMARY_SETTINGS_READ_LEN] != profiles[PROFILE1].csum)
        || ([self fletcher16Checksum:[profiles[PROFILE2] getDataArray] WithLength:BLE_DEVICE_DLC_CHAR_SECONDARY_SETTINGS_READ_LEN] != profiles[PROFILE2].csum)
        || ([self fletcher16Checksum:[globalSettings getDataArray] WithLength:BLE_DEVICE_DLC_CHAR_GLOBAL_SETTINGS_READ_LEN] != globalSettings.csum)
        )
    {
        changed = true;
    }
    return (changed);
}

-(bool)userChangedExtendProfileSettings
{
    bool changed = false;
    
    if (
        ([self fletcher16Checksum:[self getScheduleDataArrayFor:PROFILE1] WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN] != extendCsum[PROFILE1])
        ||
        ([self fletcher16Checksum:[self getScheduleDataArrayFor:PROFILE2] WithLength:BLE_DEVICE_DLC_CHAR_EXTEND_SECONDARY_READ_LEN] != extendCsum[PROFILE2])
        )
    {
        changed = true;
    }
    
    return (changed);
}

- (UInt16) fletcher16Checksum:(UInt8*)data WithLength:(UInt8)length
{
    UInt16 sum1 = 0;
    UInt16 sum2 = 0;
    
    for (int index = 0; index < length; index++)
    {
        sum1 = (sum1 + data[index]) % 255;
        sum2 = (sum2 + sum1) % 255;
    }
    
    return ((sum2 << 8) | sum1);
}

-(void) checkBytes:(UInt16)fletcherChecksum
{
    UInt8 c0, c1, f0, f1;
    
    f0 = (fletcherChecksum & 0xff);
    f1 = (fletcherChecksum >> 8) & 0xff;
    c0 = 0xff - ((f0 + f1) % 0xff);
    c1 = 0xff - ((f0 + c0) % 0xff);
}
@end
