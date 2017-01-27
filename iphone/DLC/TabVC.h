//
//  TabBC.h
//  DLC
//
//  Created by mr king on 19/11/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DLCOne.h"
#include "BLEDevice.h"

@interface TabVC : UITabBarController <BLEDeviceDelegate>
{
    //access these properties from individual scene using parentViewController
    BLEDevice   *t;                 //TI BLE class (private)
    
    NSInteger   selectedController;
    NSInteger   selectedFile;
    
    BOOL        offline;
    DLCOne *    controller;
    
    BOOL        newStatusReceived;
    BOOL        newDeviceFound;
    BOOL        readAllDLCSettings;
    NSString *   password1;
    NSString *   password2;
    NSString *   modelNumberStr;
    BOOL        passwordIsDefault;
    bool        editingDeviceName;
}

@property (nonatomic)DLCOne *    controller;
@property (nonatomic)NSInteger selectedController;
@property (nonatomic)NSInteger selectedFile;
@property (nonatomic)BOOL offline;
@property (nonatomic)BOOL newStatusReceived;
@property (nonatomic)BOOL readAllDLCSettings;
@property (nonatomic)NSString *password1;
@property (nonatomic)NSString *password2;
@property (nonatomic)NSString *modelNumberStr;
@property (nonatomic)BOOL passwordIsDefault;
@property (nonatomic)bool editingDeviceName;

- (void)newControllerWithUUID:(NSString *)uuid;
- (void)scan;
- (int)getDevicesCount;
-(void)setWalkTestEnable:(BOOL)state;
-(void)setDaliResetTo:(int)channel;
//-(void)setDaliReset;
- (void)setLightsTo:(BOOL)state;
- (void)setLightsTo:(BOOL)state ForChannel:(int)channel;
- (void)setCalibrateSensor;
- (void)setCalibrateSensorForSelectedProfile:(int)selectedProfile;
//- (void)setDimLevelOverrideTo:(unsigned char)level;
//-(void)setDimLevelOverrideTo:(unsigned char)level ForChannel:(int)channel;
- (void)setDimLevelOverrideToA:(unsigned char)value;
- (void)setDimLevelOverrideToB:(unsigned char)value;
-(void)setEMCOverride:(unsigned char)value;
- (BOOL)passwordOK;
- (void)disconnectFromPeripherals;
- (void)disconnectFromActivePeripheral;

- (void) writeRemoteControl;
- (void) writeGlobalSettings;
- (void)readControllerSettings;
-(void) readDeviceInformation;
- (void) writeProfileSettings;
- (void) writeScheduleSettings;
- (void) writeDeviceInformation;

- (void)connectToPeripheral:(int)index;
- (void)stopScanning;
- (NSString *)getUUID:(int)index;
- (NSString *)getUUIDName:(int)index;
- (NSNumber *)getDeviceRSSI:(NSInteger)index;
-(NSString *)getmodelNumberString;
@end
