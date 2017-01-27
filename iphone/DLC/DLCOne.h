//
//  ControllerImage.h
//  DLC
//
//  Created by mr king on 23/10/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "globalSettings.h"
#import "ProfileSettings.h"
#import "ControllerStatus.h"
#import "ControllerRemote.h"

@interface DLCOne : NSObject
{
    @protected
    
    NSString*           deviceID;
    NSString *          profileFilename;
    NSString *          deviceName;
    NSString *          deviceDescriptor;
    NSString *          deviceLocation;
    int                 dlcModelNumber;
    
    GlobalSettings *    globalSettings;
    ProfileSettings*    profiles[NUM_PROFILES];
    ControllerStatus*   liveStatus;
    ControllerRemote*   remoteCommands;
    
    uint8_t extendData[NUM_PROFILES][BLE_DEVICE_DLC_CHAR_EXTEND_PRIMARY_READ_LEN];
    UInt16 extendCsum[NUM_PROFILES];    
}

@property (nonatomic)NSString *profileFilename;
//@property (nonatomic)NSString *deviceName;
//@property (nonatomic)NSString *deviceDescriptor;
//@property (nonatomic)NSString *deviceLocation;

- (id)initWithDeviceID:(NSString *)newID;
- (NSString *)getDeviceID;
- (NSString *)getDeviceName;
- (void)setDeviceNameWith:(NSString *)name;
- (void)setDeviceWithID:(NSString *)newID;
-(void)setPassword:(NSString *)newPassword;
-(NSString *)getPassword;
-(UInt8)getModelNumber;

//Profile description
-(void)setProfileName:profileName andDescription:description andLocation:location;
- (void)setDeviceDescriptorAs:(NSString *)descriptor;
-(NSString *)getProfileName;
-(NSString *)getdeviceDescription;
-(NSString *)getdeviceLocation;

// Updates - read from controller
-(void)updateAllStatusWithData:(uint8_t *)newStatus;
-(void)updateGlobalSettingsWithData:(uint8_t *)newGlobalSettings;
-(void) updateProfile:(int)profile WithData:(uint8_t *)newProfileSettings;
-(void) updateExtend:(int)profile WithData:(uint8_t *)newExtendSettings;

//Live status calls
-(DimmingFormat)getDimmingFormat;
-(void)setDimmingFormatWithState:(Switch)state;

-(Switch)getRelayStatus;
-(Switch)getDaliPowerSaveMode;
-(void)setDaliPowerSaveMode : (BOOL)state;
-(Profile)getActiveProfile;

-(int)getSinglePoleSwitch;
-(void)setSinglePoleSwitch:(int)channel;
-(int)getTimeClockEnable;
-(void)setTimeClockEnable:(int)value;

-(int)getDSTSetting;
-(void)setDSTSetting:(int)value;

-(unsigned char)getDimmingLevelA;
-(unsigned char)getDimmingLevelB;
-(unsigned char)getTimerValue;
-(Stage)getTimerStage;
-(LightLevel)getLightLevel;
//-(PIRState)getPIRState;
-(NSMutableArray *)getPIRState;
-(long)getLuxLevel;
-(int)getWalkTestStatus;



//Profile setting calls
-(void)setScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day withTime:(TimeOfDay)time;
-(TimeOfDay)getScheduleForProfile:(Profile)profile andDay:(DayOfWeek)day;
-(void)setScheduleEnable:(Switch)state;
-(BOOL)getScheduleEnable;
-(unsigned char)getTimerMaxForProfile:(Profile)selectedProfile andTimer:(Timer)timer;
-(unsigned char)getDimLevelForProfile:(Profile)selectedProfile andTimer:(Timer)timer;
-(void)setTimerMaxForProfile:(Profile)selectedProfile andTimer:(Timer)timer withValue:(unsigned char)timerMax;
-(void)setDimLevelForProfile:(Profile)selectedProfile andTimer:(Timer)timer withValue:(unsigned char)dimLevel;
-(BOOL)getAbsenceEnableForProfile:(Profile)selectedProfile;
//-(BOOL)getDaylightLinkEnableForProfile:(Profile)selectedProfile;
//-(unsigned char)getLinkDelayForProfile:(Profile)selectedProfile forOnDelay:(BOOL)on;
//-(void)setLinkDelayForProfile:(Profile)selectedProfile forOnDelay:(BOOL)on withValue:(unsigned char)delay;
//-(BOOL)getDaylightHarvesEnableForProfile:(Profile)selectedProfile;
-(long)getPhotocellCalibrationForProfile:(Profile)selectedProfile;
-(void)setAbsenceEnableForProfile:(Profile)selectedProfile withState:(Switch)state;
//-(void)setDaylightLinkEnableForProfile:(Profile)selectedProfile withState:(Switch)state;
//-(void)setDaylightHarvesEnableForProfile:(Profile)selectedProfile withState:(Switch)state;
-(void)setPhotocellCalibrationForProfile:(Profile)selectedProfile withCalibrationValue:(uint)calVal;
-(unsigned char)getDLCFirmwareVersion:(BOOL)version;

-(BOOL)getbrightOutEnableForProfile:(Profile)selectedProfile;
-(int)getChannelFunctionForProfile:(Profile)selectedProfile;
-(BOOL)getConstantLightEnableForProfile:(Profile)selectedProfile;
-(void)setbrightOutEnableForProfile:(Profile)selectedProfile withState:(Switch)state;
-(void)setConstantLightEnableForProfile:(Profile)selectedProfile withState:(Switch)state;
-(void)setChannelFunctionForProfile:(Profile)selectedProfile withValue:(int)value;
-(int)getExitDelayTimer:(Profile)selectedProfile;
-(void)setExitDelayTimer:(Profile)selectedProfile withValue:(int)value;

-(unsigned char)getPirEnableMask;
-(void)setPirEnableMask :(unsigned char)value;

//-(int)getPirEnableMask;
//-(void)setPirEnableMask :(int)value;


//Remote command calls
-(void)setCalibrateSensorTo:(int)value;

-(void)setSwitchOverrideTo:(Byte)manualState;
-(void)setwalkTestEnableOverrideTo:(Byte)level;
-(void)setDaliResettoTo:(int)channel;


-(void)setDimLevelOverrideToA:(unsigned char)value;
-(void)setDimLevelOverrideToB:(unsigned char)value;
-(void)setEMCOverride:(unsigned char)value;


-(void)setPirEnableCheckboxTo:(int)value ForProfile:(int)selectedProfile;
-(int)getPirEnableCheckBoxTo :(int)selectedProfile;

-(signed int)getMimicChannel1Value:(int)selectedProfile;
-(void)setMimicChannel1Value:(signed int)value ForProfile:(int)selectedProfile;


-(ControllerRemote*)getRemoteCommands;
-(GlobalSettings *)getGlobalSettings;
-(ProfileSettings *)getProfileSettingsFor:(int)profile;


//simulation code
-(void)initialiseControllerData;
- (NSString *)dataFilePath:(BOOL)forSave andWithFilename:(NSString *)filename;

//parser
- (BOOL)loadDLCOneConfigurationFromFile:(NSString *)filename;
- (void)saveDLCOneConfigurationToFilename:(NSString *)filename;

//settings changed
- (void)updateDLCGlobalSettingsChecksum:(UInt8*)data WithLength:(UInt8)length;
-(void)updateDLCProfileChecksumForProfile:(Profile)profile ForData:(UInt8*)data WithLength:(UInt8)length;
-(void)updateDLCExtendChecksumForProfile:(Profile)profile ForData:(UInt8*)data WithLength:(UInt8)length;
-(void)updateModelNo:(char)modelNumber;
-(void)updateDeviceNameWith:(NSString *)newDeviceName;
-(UInt8 *)getScheduleDataArrayFor:(Profile)profile;

-(bool)userChangedSettings;
-(bool)userChangedGlobalSettings;
-(bool)userChangedProfileSettings;
-(bool)userChangedExtendProfileSettings;

//new

- (BOOL)loadiDimOrbitConfigurationFromFile:(NSString *)filePath;





@end
